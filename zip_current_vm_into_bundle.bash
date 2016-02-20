function zip_up_the_vm_into_temp() {
    
    cd "$GOPATH"
    
    while [ -e "$_PATH_AND_FILE_TO_WRITE" ]
    do 
        _PATH_AND_FILE_TO_WRITE="$_ZIPED_MACHINES_FOLDER_PATH/$_ZIPED_MACHINES_FOLDER_NAME/$_ZIP_FILE_NAME-$_ZIP_FILE_MODIFIER.$_ZIP_FILE_EXTENSION";
        let "_ZIP_FILE_MODIFIER = $_ZIP_FILE_MODIFIER + 1"
    done
    
    
    local _user_response;
    printf "CREATE : '%s'" "$_PATH_AND_FILE_TO_WRITE";
    read -p " ? " _user_response;
    
    zip -r "$_PATH_AND_FILE_TO_WRITE" . -x "*.c9*" "*c9_vm_zips*"
}

function unzip_bundle_into_temp() {
    unzip "$_ZIPED_MACHINES_BUNDLE_PATH" -d "$_TEMP_DIR_PATH"
}

function zip_up_temp_into_bundle() {
    
    echo "_TEMP_DIR_PATH = $_TEMP_DIR_PATH";
    read -p "zip bundle ? " _pause
    zip -rj "$_TEMP_DIR_PATH/temp_bundle.zip" "$_TEMP_DIR_PATH/."
}

function move_temp_bundle_to_zipped_machine_folder() {
    if [ -e "$_ZIPED_MACHINES_BUNDLE_PATH" ]
    then
        mv "$_ZIPED_MACHINES_BUNDLE_PATH" "$_ZIPED_MACHINES_BUNDLE_PATH-archived"
    fi
    
    mv "$_TEMP_DIR_PATH/temp_bundle.zip" "$_ZIPED_MACHINES_BUNDLE_PATH";
    #rename "$_ZIPED_MACHINES_FOLDER_PATH/temp_bundle.zip" "$_ZIPED_MACHINES_BUNDLE_PATH"
}

function init() {
    local _ZIP_FILE_MODIFIER=1;
    local _ZIP_FILE_NAME="$C9_PROJECT";
    local _TEMP_DIR_NAME="TEMP";
    local _TEMP_DIR_PATH="$PWD/$_TEMP_DIR_NAME";
    local _ZIPED_MACHINES_FOLDER_NAME="zipped_machines";
    local _ZIPED_MACHINES_FOLDER_PATH="$PWD/$_ZIPED_MACHINES_FOLDER_NAME";
    local _ZIP_FILE_EXTENSION="zip";
    
    local _PATH_AND_FILE_TO_WRITE="$_TEMP_DIR_PATH/$_ZIP_FILE_NAME.$_ZIP_FILE_EXTENSION";
    
    local _ZIPED_MACHINES_BUNDLE_NAME="zipped_machines_bundle";
    local _ZIPED_MACHINES_BUNDLE_PATH="$_ZIPED_MACHINES_FOLDER_PATH/$_ZIPED_MACHINES_BUNDLE_NAME.$_ZIP_FILE_EXTENSION";
    
    if [ ! -d "$_TEMP_DIR_PATH" ]
    then
        mkdir "$_TEMP_DIR_PATH"
    fi
    
    if [ ! -d "$_ZIPED_MACHINES_FOLDER_PATH" ]
    then
        mkdir "$_ZIPED_MACHINES_FOLDER_PATH";
    fi
    
    zip_up_the_vm_into_temp;
    
    if [ -e "$_ZIPED_MACHINES_BUNDLE_PATH" ]
    then
        unzip_bundle_into_temp;
        mv "$_ZIPED_MACHINES_BUNDLE_PATH" "$_ZIPED_MACHINES_BUNDLE_PATH-archived"
    fi
    
    zip_up_temp_into_bundle;
    move_temp_bundle_to_zipped_machine_folder;
    #add_vm_to_bundle;
    
    rm -rf "$_TEMP_DIR_PATH"
}

init

:<<'EOF'
cd "$GOPATH"
zip -r workspaceScriptZipped.zip . -x *.c9*
( set -o posix ; set ) | less > temp.txt

function add_vm_to_bundle() {
    
    local _temp_dir_for_bundling="$_TEMP_DIR_PATH/$_ZIPED_MACHINES_FOLDER_NAME/$_TEMP_DIR_NAME";
    if [ ! -d "$_temp_dir_for_bundling" ]
    then
        mkdir "$_temp_dir_for_bundling"
    fi
    
    local _bundle_path_and_name="$_ZIPED_MACHINES_FOLDER_PATH/$_ZIPED_MACHINES_FOLDER_NAME/$_ZIPED_MACHINES_BUNDLE_FILE_NAME.$_ZIP_FILE_EXTENSION";
    if [ -e "$_bundle_path_and_name" ]
    then
        unzip "$_bundle_path_and_name" "$_temp_dir_for_bundling"
    fi
    
    echo "_PATH_AND_FILE_TO_WRITE = $_PATH_AND_FILE_TO_WRITE"
    read -p " cont : " _pause
    cp "$_PATH_AND_FILE_TO_WRITE" "$_temp_dir_for_bundling";
    
    local _modifier_count=1;
    
    while [ -e "$_bundle_path_and_name" ]
    
    do
        _bundle_path_and_name="$_ZIPED_MACHINES_FOLDER_PATH/$_ZIPED_MACHINES_FOLDER_NAME/$_ZIPED_MACHINES_BUNDLE_FILE_NAME-$_modifier_count.$_ZIP_FILE_EXTENSION";
        let "_modifier_count = $_modifier_count + 1";
    done
    
    
    echo "_bundle_path_and_name = $_bundle_path_and_name"
    echo "_temp_dir_for_bundling = $_temp_dir_for_bundling"
    
    zip -r "$_bundle_path_and_name" "$_temp_dir_for_bundling";
    # zip -r "$_temp_dir_for_bundling" "$_bundle_path_and_name";
    read -p " cont : " _pause
    rm -rf "$_temp_dir_for_bundling";
    #if [ -e ]
}
EOF
