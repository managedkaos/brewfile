import subprocess
import json

def parse_brew_outdated():
    try:
        # Execute brew outdated command and capture output
        result = subprocess.run(["brew", "outdated", "--greedy", "--json"], capture_output=True, text=True)

        # Parse JSON output
        outdated_data = json.loads(result.stdout)

        # Extract cask information
        casks = outdated_data.get("casks", [])

        return casks
    except Exception as e:
        print("Error occurred while executing brew command:", e)
        return []

def check_upgrade_eligibility(installed_version, current_version):
    try:
        # Split version numbers into parts
        installed_major, installed_minor, _ = map(int, installed_version.split('.')[:2])
        current_major, current_minor, _ = map(int, current_version.split('.')[:2])

        # Check upgrade criteria
        if current_major == installed_major + 1:
            return True, "MAJOR version is 1 greater than installed version"
        elif current_minor >= installed_minor + 3:
            return True, "MINOR version is at least 3 versions greater than installed version"
        else:
            return False, "Neither MAJOR nor MINOR version upgrade criteria met"
    except Exception as e:
        print("Error occurred while checking upgrade eligibility:", e)
        return False, "Error occurred"

def main():
    # Parse brew outdated data
    casks = parse_brew_outdated()

    if not casks:
        print("No outdated casks found.")
        return

    upgrade_candidates = []
    do_not_upgrade = []
    string_versions = []

    # Iterate through casks
    for cask in casks:
        name = cask["name"]
        installed_version = cask["installed_versions"][0]
        current_version = cask["current_version"]

        # Check if major or minor versions contain strings
        if any(part.isalpha() for part in installed_version.split('.')[:2] + current_version.split('.')[:2]):
            string_versions.append(name)
            continue

        # Check upgrade eligibility
        upgrade_eligible, reason = check_upgrade_eligibility(installed_version, current_version)

        # Classify casks
        if upgrade_eligible:
            upgrade_candidates.append((name, reason))
        else:
            do_not_upgrade.append((name, reason))

    # Display cask classification
    print("Upgrade Candidates:")
    for name, reason in upgrade_candidates:
        print(f"{name}: {reason}")

    print("\nDo Not Upgrade:")
    for name, reason in do_not_upgrade:
        print(f"{name}: {reason}")

    print("\nVersions with Strings:")
    for name in string_versions:
        print(name)

if __name__ == "__main__":
    main()
