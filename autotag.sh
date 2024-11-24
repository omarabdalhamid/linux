      #!/bin/bash

      # Fetch all tags
      git fetch --tags

      # Get the latest tag
      LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1) 2>/dev/null)

      # If no tags exist, start with v0.1.0
      if [ -z "$LATEST_TAG" ]; then
        NEW_TAG="v0.1.0"
      else
        # Extract major, minor, and patch versions using regex
        if [[ $LATEST_TAG =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
          MAJOR=${BASH_REMATCH[1]}
          MINOR=${BASH_REMATCH[2]}
          PATCH=${BASH_REMATCH[3]}
          
          # Increment the patch version (logic can be customized)
          PATCH=$((PATCH + 1))
          NEW_TAG="v$MAJOR.$MINOR.$PATCH"
        else
          echo "Error: Current tag format is incorrect: $LATEST_TAG"
          exit 1
        fi
      fi

      # Authenticate and push the new tag
      git remote set-url origin https://$releaseuser:$releasetoken@gitlab.tamra.io/$CI_PROJECT_PATH.git

      # Create and push the new tag
      git tag $NEW_TAG
      git push origin $NEW_TAG

      echo "New tag created and pushed: $NEW_TAG"

      echo "NEW_TAG=$NEW_TAG" > tag.env

      source tag.env

      # Create a release using the GitLab API
      curl --request POST --header "PRIVATE-TOKEN: $releasetoken" \
        --header "Content-Type: application/json" \
        --data '{
          "name": "'"$NEW_TAG"'",
          "tag_name": "'"$NEW_TAG"'",
          "description": "Release for tag '"$NEW_TAG"'"
        }' \
        "https://gitlab.tamra.io/api/v4/projects/$CI_PROJECT_ID/releases"

      echo "Release created for tag: $NEW_TAG"
