print("hallo")
import numpy as np
import SimpleITK as sitk
import os

dir = "/data/probst/frombara/segmentation/"


m =["C0005362",
"C0005365",
"C0005371",
"C0005380",
"C0005385",
"C0005386",
"C0005557",
"C0005568",
"C0005773",
"C0005777",
"C0005779",
"C0005782",
"C0005785",
"C0005787",
"C0005786",
"C000579"]

pm = ["C0005333",
"C0005767",
"C0005766",
"C0005768",
"C0005769",
"C0005776",
"C0005784",
"C0005798",
"C0005799",
"C0005806"]

for root, dirs, files in os.walk(dir):
    for dirname in dirs:
        if any(id in dirname for id in pm):
            schmelz = "";
            dentin = "";
            x=y=z = 0;
            for troot, tdirs, tfiles in os.walk(os.path.join(root, dirname)):
                for tfile in tfiles:
                    if "schmelz" in troot and "seg_result" in troot and "mhd" in tfile:
                        schmelz = sitk.ReadImage(os.path.join(troot, tfile))
                        x, y, z = schmelz.GetSize()
                    if "dentin" in troot and "seg_result" in troot and "mhd" in tfile:
                        dentin = sitk.ReadImage(os.path.join(troot, tfile)) 
            
            if schmelz != dentin: 
                print(os.path.join(root, dirname))
                

                img_schmelz = sitk.GetArrayFromImage(schmelz)
                img_dentin = sitk.GetArrayFromImage(dentin)
                img_combined = img_schmelz + img_dentin * 2
                print(np.isin(3,img_combined))
                seedList = [(0, 0, 0),
            (0, 0, z),
            (0, y, 0),
            (0, y, z),
            (x, 0, 0),
            (x, 0, z),
            (x, y, 0),
            (x, y, z), ]
                img = sitk.GetImageFromArray(img_combined)
                air_img = sitk.ConnectedThreshold(img, seedList=seedList, lower=0, upper=0)

                air = sitk.GetArrayFromImage(air_img)
                img_combined = img_combined + 4*air
                img_combined = np.where(img_combined == 0, 3, img_combined)
                img_combined = np.where(img_combined == 4, 0, img_combined)
                img = sitk.GetImageFromArray(img_combined)

                sitk.WriteImage(img, os.path.join(root, dirname, dirname+".mhd"))

                #img = sitk.ReadImage(os.path.join(root, dirname, dirname+".mhd"))
                #img = sitk.GetArrayFromImage(img)
                print("0" + str(np.isin(0,img_combined)))
                print("1" + str(np.isin(1,img_combined)))
                print("2" + str(np.isin(2,img_combined)))
                print("3" + str(np.isin(3,img_combined)))



        