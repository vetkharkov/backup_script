
# PARSER JQ
sudo apt install jq

jq -r ".author" backup_config.json # Vitaliy Bindyug

jq -r ".backups[0]" backup_config.json 
{
  "backup_name": "backup_folder_1",
  "source_folder": "/home/vet/app/backup_script/Folder-1",
  "target_folder": "./my_backups"
}

jq -r ".backups | length" backup_config.json # 3

touch backup_script.sh
chmod a+x backup_script.sh
./backup_script.sh
