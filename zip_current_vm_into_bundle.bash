function zip_up_the_vm() {
    
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

function init() {
    local _ZIP_FILE_MODIFIER=1;
    local _ZIP_FILE_NAME="$C9_PROJECT";
    local _ZIPED_MACHINES_FOLDER_PATH="$PWD"
    local _TEMP_DIR_NAME="TEMP";
    local _TEMP_DIR_PATH="$PWD/$_TEMP_DIR_NAME";
    local _ZIPED_MACHINES_FOLDER_NAME="zipped_machines";
    local _ZIP_FILE_EXTENSION="zip";
    
    local _PATH_AND_FILE_TO_WRITE="$_TEMP_DIR_PATH/$_ZIP_FILE_NAME.$_ZIP_FILE_EXTENSION";
    
    local _ZIPED_MACHINES_BUNDLE_FILE_NAME="zipped_machines_bundle";
    
    mkdir "$_TEMP_DIR_PATH"
    zip_up_the_vm;
    #add_vm_to_bundle;
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
