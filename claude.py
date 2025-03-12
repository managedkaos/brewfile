#!/usr/bin/env python3
import argparse
import os
import subprocess

from langchain.output_parsers import PydanticOutputParser
from langchain_core.prompts import ChatPromptTemplate
from langchain_ollama.llms import OllamaLLM
from pydantic import BaseModel, Field


class Commit_Message(BaseModel):
    title: str = Field(description="a one-line summary of the commit")
    body: str = Field(description="a more detailed summary of the commit")


def get_git_diff(compare_branch="HEAD~1"):
    """Get the git diff between the current working directory and the specified branch."""
    try:
        # Run git diff command and capture output
        result = subprocess.run(
            ["git", "--no-pager", "diff", compare_branch],
            capture_output=True,
            text=True,
            check=True,
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error running git diff: {e}")
        print(f"stderr: {e.stderr}")
        return None


def summarize_diff(diff_text, model_name="phi4:latest"):
    """Use Ollama to summarize the git diff."""
    if not diff_text or diff_text.strip() == "":
        return "No changes detected."

    # Create a prompt template that instructs the model to create a good commit message
    template = """You are a helpful assistant that generates concise and informative git commit messages.

Below is a git diff. Please analyze it and create a commit message that:

1. Summarizes the changes in a short (50-80 characters) title line
2. Do not include text before the title line
3. If needed, includes a more detailed description after a blank line
4. Uses the imperative mood (e.g., "Add feature" not "Added feature")
5. Focuses on what changes and why, not how

Git Diff:
{diff}

"""

    prompt = ChatPromptTemplate.from_template(template)
    model = OllamaLLM(model=model_name, temperature=0.2)
    parser = PydanticOutputParser(pydantic_object=Commit_Message)
    chain = prompt | model | parser

    try:
        # If the diff is too large, we might need to truncate it
        max_diff_length = 15000  # Adjust based on model capabilities
        truncated_diff = (
            diff_text[:max_diff_length] + "..."
            if len(diff_text) > max_diff_length
            else diff_text
        )

        result = chain.invoke({"diff": truncated_diff})
        return result
    except Exception as e:
        print(f"Error summarizing diff: {e}")
        return "Error generating commit message."


def main():
    parser = argparse.ArgumentParser(
        description="Generate commit messages from git diffs using Ollama"
    )
    parser.add_argument(
        "--branch",
        "-b",
        default="main",
        help="Branch to compare against (default: main)",
    )
    parser.add_argument(
        "--model",
        "-m",
        default="phi4:latest",
        help="Ollama model to use (default: phi4:latest)",
    )
    parser.add_argument("--output", "-o", help="Output file (default: print to stdout)")
    args = parser.parse_args()

    # Check if current directory is a git repository
    if not os.path.exists(".git"):
        print("Error: Not a git repository")
        return

    # Get the diff
    diff = get_git_diff(args.branch)
    if not diff:
        print("Could not get git diff")
        return

    # Summarize the diff
    summary = summarize_diff(diff, args.model)

    # Output the result
    print(summary)

    if args.output:
        with open(args.output, "w") as f:
            f.write(summary)
        print(f"Commit message saved to {args.output}")


if __name__ == "__main__":
    main()
