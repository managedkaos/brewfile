#!/bin/bash

# This script will backup all Zoom chat files to a specified directory.
git -C ~/Documents/Zoom add .
git -C ~/Documents/Zoom commit -m "Backup Zoom chats"
git -C ~/Documents/Zoom push origin main

