//Select folder
showMessage("Select open folder which saves DIC2Cell binarized images");
openDir1 = getDirectory("Choose a Directory");
showMessage("Select open folder which saves organellar gray-scale images");
openDir2 = getDirectory("Choose a Directory");
showMessage("Select save folder you want to save ROIs-transfered images");
saveDir1 = getDirectory("Choose a Directory");
showMessage("Select save folder you want to save single-cell images");
saveDir2 = getDirectory("Choose a Directory");
list1 = getFileList(openDir1);
list2 = getFileList(openDir2);

for(i=0; i<list1.length;i++){
    operation();
};
print("Macro Finished");


//Define operations
function operation(){

    //Open DIC2Cell binarized images
    open(openDir1 + list1[i]);
    name1 = getTitle;
    dotIndex1 = indexOf(name1, ".");
    title1 = substring(name1, 0, dotIndex1);

    //Set ROIs for each individual cell
    run("Erode");
    run("Dilate");
    run("Analyze Particles...", "size=2000-Infinity pixel show=Overlay exclude add");

    //Open ROI Manager for DIC2Cell binarized images
    selectWindow(list1[i]);
    numROIs = roiManager("count");
    close(list1[i]);

    //Open organellar gray-scale images
    open(openDir2 + list2[i]);
    name2 = getTitle;
    dotIndex2 = indexOf(name2, ".");
    title2 = substring(name2, 0, dotIndex2);

    //Transfer ROIs toward mitochondrial gray-scale images from DIC2Cell binarized images
    for(j=0; j<numROIs;j++){
    	roiManager("Select", j);
    	selectWindow(title2 + ".tif");
    	run("Add Selection...");
    };

    //Save ROIs-transfered images
    saveAs("tif", saveDir1 + title2); 

    //Crop and save individual cell images (organelle)
    run("To ROI Manager");
    numROIs = roiManager("count");
    for(k=0; k<numROIs;k++){
    	selectWindow(title2 + ".tif");
    	run("Duplicate...", " ");
    	roiManager("Select", k);
    	run("Add Selection...");
	    run("Crop");
	    setBackgroundColor(0, 0, 0);
	    run("Clear Outside");
	    run("Add Selection...");
	    run("Canvas Size...", "width=1024 height=1024 position=Center");
	    newname = title2 + "-" + k+1 + ".tif";
        rename(newname);
        saveAs("tif", saveDir2 + newname);
        close(newname);
    };

    //Close images
    close(list2[i]);
    
    //Reset ROI Manager
    roiManager("reset");
    close("*");
    
};

