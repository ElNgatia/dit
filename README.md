
# Repository Management Tool Documentation

This is a custom version control system implemented in Dart. It allows you to initialize repositories, clone them, and manage commits, branches, and more.

## Prerequisites

1.  **Install Dart SDK**:
    
    -   Ensure Dart is installed on your system.
    -   Follow the instructions [here](https://dart.dev/get-dart) to install Dart.

2.  **Verify Dart Installation**:
        
    `dart --version` 
    
3.  **Get the Repository Code**:
    
    -   Clone or download the project into your local environment.
4.  **Navigate to the Project Directory**:
    
    `cd <project-directory>` 
    

## Setup and Running the Tool

### 1. Run the `init` Command

Initialize a new repository:

`dart run bin/dit.dart init` 

**Expected Output**:


`Initialized empty repository in .dit` 

**Result**:

-   A `.dit` directory is created in the current folder, containing:
    -   `HEAD` file pointing to `refs/heads/main`
    -   `refs/heads/main` file for tracking the main branch
    -   `objects` directory for storing commits and files
    -   `index` file for tracking staged changes
    -   `.ditignore` file for ignored files

----------

### 2. Add Files to the Repository

Add files to the staging area:

`echo "Hello, World!" > test.txt`

`dart run bin/dit.dart add test.txt` 

**Expected Output**:

`Added test.txt to staging.` 

**Result**:

-   The `index` file in `.dit` now tracks the staged file `test.txt`.

----------

### 3. Commit Changes

Create a commit with the staged changes:

`dart run bin/dit.dart commit -m "Initial commit"` 

**Expected Output**:

`Committed changes as <commit-id>.` 

**Result**:

-   A new commit object is created in `.dit/objects`.
-   The `refs/heads/main` file points to the new commit ID.

----------

### 4. Create and Checkout Branches

Create a new branch:

`dart run bin/dit.dart branch feature` 

**Expected Output**:


`Created branch feature at commit <commit-id>.` 

Switch to the new branch:


`dart run bin/dit.dart checkout feature` 

**Expected Output**:


`Switched to branch feature.` 

----------

### 5. Clone the Repository

Clone the repository to another directory:

`dart run bin/dit.dart clone <target-directory>` 

**Expected Output**:


`Cloned repository to <target-directory>.` 

----------

### 6. View Repository Structure

After initializing and committing, the `.dit` directory structure should look like this:
```
.dit/
├── HEAD                 # Points to the current branch
├── index                # Tracks staged files
├── refs/
│   ├── heads/
│   │   ├── main         # Points to the latest commit ID on the main branch
│   │   └── feature      # (Optional) Points to the latest commit ID on the feature branch
├── objects/             # Stores commit and file objects
└── .ditignore           # Patterns for ignored files`
```
----------

### 7. Clean Repository

If needed, delete the `.dit` folder to remove all repository data:


`rm -rf .dit` 

----------

## Commands Summary

| COMMAND                               | DESCRIPTION                                            |
|---------------------------------------|--------------------------------------------------------|
| dart run bin/dit.dart init            | Initializes a new repository in the current directory. |
| dart run bin/dit.dart add <file>      | Stages the specified file for the next commit.         |
| dart run bin/dit.dart commit -m <msg> | Commits staged changes with the given message.         |
| dart run bin/dit.dart branch <name>   | Creates a new branch with the specified name.          |
| dart run bin/dit.dart checkout <name> | Switches to the specified branch.                      |
| dart run bin/dit.dart clone <dir>     | Clones the repository to the specified directory.      |


----------

## Notes

-   **Ignored Files**: Use `.ditignore` to specify files or patterns to ignore during staging.
    
    -   Example `.ditignore`:
                
        `*.log
        build/
        secret.txt` 
        
-   **Dependencies**: Ensure the project dependencies in `pubspec.yaml` are installed:
    
    `dart pub get` 
    
-   **Testing**: Add tests for your commands in the `test` directory and run:
   
    
    `dart test`