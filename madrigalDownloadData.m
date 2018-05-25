% Program that can download PFISR data files
% Run madrigalkindatfilter.m before this to obtain expFileArrayStore which
% contains all the file names that use the Baker Code 

startdate = datenum('08/01/2017');
enddate = datenum('08/31/2017');
PATH = getenv('PATH');
setenv('PATH', [PATH ':/usr/local/Cellar/wget/1.19.5/bin']); %must have wget downloaded before this step. If using mac OS X 10.7 or better, go to https://brew.sh for more instructions                                                     
madurl = 'http://madrigal.haystack.mit.edu/madrigal';
cgiurl = getMadrigalCgiUrl(madurl);

% List all instruments, and their latitudes and longitudes:'
instArray = getInstrumentsWeb(cgiurl);

% now list all experiments from local Madrigal site with mlh (code 30) in
expArray = getExperimentsWeb(cgiurl, 30, startdate, enddate, 1);

    
expFileArray = getExperimentFilesWeb(cgiurl, expArray(10).id);

filename = expFileArray(12).kindatdesc;
filename = strrep(filename, ' ' , '-');

% download that data file in simple format
result = madDownloadFile(cgiurl, expFileArray(12).name, sprintf('/Users/ashakigumbs/Documents/MATLAB/Research_Semeter_Group/madmatlab/%s.hdf5', filename), 'Ashaki Gumbs', 'agumbs@bu.edu', 'Boston University', 'hdf5');

% %


% %%
%  lengthexpArray = length(expArray);
%  for i = 1:lengthexpArray
%      expFileArray = getExperimentFilesWeb(cgiurl, expArray(i).id)
%      for j = 1:length(expFileArray)
%          filename = expFileArray(j).kindatdesc;
%          filename = strrep(filename, ' ' , '_');
%          result = madDownloadFile(cgiurl, expFileArray(j).name, sprintf('/Users/ashakigumbs/Documents/MATLAB/Research_Semeter_Group/Date/%s.hdf5', filename), 'Ashaki Gumbs', 'agumbs@bu.edu', 'Boston University', 'hdf5');
%      end
%  end
     

