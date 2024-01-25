//Select folder
showMessage("Select Open Folder");
openDir = getDirectory("Choose a Directory");
showMessage("Select Save Folder");
saveDir = getDirectory("Choose a Directory");
list = getFileList(openDir);


for(i=0; i<list.length;i++){
    operation();
};

print("Macro Finished");

//Define operations
function operation(){

    //Open images
    open(openDir + list[i]);
    name = getTitle;
    dotIndex = indexOf(name, ".");
    title = substring(name, 0, dotIndex);
    selectWindow(list[i]);
    run("Remove Overlay");
    run("Convert to Mask");
       
    //Measure morphological features of individual cells
    run("Set Measurements...", "area perimeter fit shape redirect=None decimal=3");
    selectWindow(list[i]);
    run("Analyze Particles...", "size=0-Infinity exclude summarize");
    close(list[i]);
    close("roiManager");
    
};


//Save quantitative data
newname = "Morphology" + ".csv";
saveAs("Summary", saveDir + newname);

//Clear Results and ROI Manager
close("Summary");
close("roiManager");

