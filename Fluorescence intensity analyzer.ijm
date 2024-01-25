//Select folder
showMessage("Select open folder which saves OrgaSegNet organelle images");
openDir1 = getDirectory("Choose a Directory");
showMessage("Select open folder which saves Raw organelle images");
openDir2 = getDirectory("Choose a Directory");
showMessage("Select save folder");
saveDir = getDirectory("Choose a Directory");
list1 = getFileList(openDir1);
list2 = getFileList(openDir2);

Table.create("Table");

for(i=0; i<list1.length;i++){
    operation();
};
print("Macro Finished");

//Define operations
function operation(){

    //Open a binarized-organellar image
    open(openDir1 + list1[i]);
    name1 = getTitle;
    dotIndex1 = indexOf(name1, ".");
    title1 = substring(name1, 0, dotIndex1);

    //Extract each ROI of individual organelles
    run("Remove Overlay");
    run("Convert to Mask");
    run("Analyze Particles...", "size=2-Infinity add");
    numROIs = roiManager("count");

    //Open a raw-organelle image
    open(openDir2 + list2[i]);
    name2 = getTitle;
    dotIndex2 = indexOf(name2, ".");
    title2 = substring(name2, 0, dotIndex2);

    //Transfer ROIs to the raw-nucleoid image
    selectWindow(list2[i]);
    run("Remove Overlay");
    for(j=0; j<numROIs;j++){
        roiManager("Select", j);
        roiManager("Add");
    };

    //Measure fluorescence intensity in each individual cells 
    numROIs = roiManager("count");
    run("Set Measurements...", "mean display redirect=None decimal=3");
    for(k=0; k<numROIs;k++){
        roiManager("Select", k);
        roiManager("Measure"); 	
    };
    run("Summarize");
    
    for(k=0; k<numROIs;k++){
    	Table.deleteRows(i, i);
    };
    
    for(k=0; k<3;k++){
    	Table.deleteRows(i+1, i+1);
    };
    
    selectWindow("Table");
    Table.set("Imag.No", i, title2);
    Table.set("MFI", i, getResult("Mean", 0));
    run("Clear Results"); 
        
    close(list1[i]);
    close(list2[i]);

    //Reset ROI Manager
    roiManager("reset");
    close("*");
    
};

//Save quantitative data
Table.update;
Table.rename("Table", "Results")
saveAs("Results", saveDir + "Fluorescence intensity of individual organelles" + ".csv");
