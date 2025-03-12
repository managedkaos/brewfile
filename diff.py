from git import Repo, diff

REPO_PATH =  "."
repo = Repo(REPO_PATH)

diffs = repo.index.diff("HEAD~1")

for d in diffs:
    print(d.a_path)

diff = repo.git.diff()
print(diff)
