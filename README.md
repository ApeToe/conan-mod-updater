# conan-mod-updater

A mod updater designed for Conan Exiles dedicated servers running on Linux, but could be easily modified to work for most games.

## Prerequisites
- Linux operating system
- Conan Exiles dedicated server
- Bash shell

## Installation

1. Clone this repository to your local machine:
git clone https://github.com/your-username/conan-mod-updater.git

2. Place the script (`update-mods.sh`) anywhere in your system.

3. Create a file named `mods.txt` in the same directory as the script. Each line in this file should contain the mod ID of the mods you want to update. For example:
mod_id_1
mod_id_2
mod_id_3


## Configuration

Before running the updater script, you need to configure your Conan directory.

1. Open the `update-mods.sh` script using a text editor.

2. Locate the following line:
```MODS_LOCATION="CONANDIRECTORY/ConanSandbox/Mods"
  INSTALL_DIR="CONANDIRECTORY"  # Modify this line with the desired installation path
Replace CONANDIRECTORY with the actual path to your Conan directory.
Usage
To update the mods, follow these steps:

Open a terminal and navigate to the directory where you placed the update-mods.sh script.

Make the script executable by running the following command:

chmod +x update-mods.sh
Run the updater script using the following command:

./update-mods.sh
The script will read the mods.txt file and update the listed mods in your Conan Exiles dedicated server.

Contributing
Contributions are welcome! If you have any improvements or bug fixes, feel free to submit a pull request.