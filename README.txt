

madrigalDownloadData.m downloads the data from the necessary experiment in 

hdf5 format. It is used in conjunction with getCgiurlForExperiment.m,
 
getExperimentFilesWeb.m, getExperimentsWeb.m., and madDownloadFile.m.



returnmatrix.m returns the range, timestamps, and matrix necessary to 

plot the data you are trying to view. Once this data is returned, the input 

of your plotting function is the range, timestamp, and matrix. 


Downloading wget on MAC: go to https://brew.sh for instructions on how to download this. 

Macintosh computers do not come with wget and will need to be installed. After the

installation, the installer will tell you where this file is located. However, MATLAB  

doesn't know where the function is. You have to manually tell give it a path so that it 

effectively use the system(....) function. To do this, in your main script before anything  

else is ran, put:

PATH = getenv('PATH');
setenv('PATH', [PATH ':/usr/local/desiredpath']) 

where the desired path is the location of wget on your computer. 

                                                   



