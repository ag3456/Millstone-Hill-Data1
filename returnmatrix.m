function [propertime, range, matrix, TID] = returnmatrix(filename, totype, varargin)
%this file returns the matrix  of the datatype of a specific
%file you are interested in with or without parameters
%[propertime, range, matrix, TID] = returnmatrix(filename, totype,
%[fromrange torange fromtime(HH:mm:ss) totime(HH:mm:ss)])
%this code only uses zenith single-pulse code, not alternating.
%general code will be made for combined parameters once website is started

%filename = '/Users/ashakigumbs/Documents/MATLAB/Research_Semeter_Group/madmatlab/Zenith-single-pulse-basic-parameters.hdf5';
%naffile = 'Temporary1.hdf5';
S = hdf5info(filename); 
data = h5read(filename, '/Data/Table Layout');
range = h5read(filename, '/Data/Array Layout/Array with kinst=32 and mdtyp=115 and pl=0.00048 /range'); %return an array of the range of the experiment
time = h5read(filename, '/Data/Array Layout/Array with kinst=32 and mdtyp=115 and pl=0.00048 /timestamps'); %return an array of the timestamps in the experiment
type = totype; %the particular data you're requesting. 'ne' for electrondensity, look at table description in hdf5 file 
datainterested = data.(totype); %index into struct to get data that you're interested in
matrix = [];
z = length(range);
l = 1;

for i = 1:length(time) %create matrix for electron density with respect to range
    matrix(:,i) = datainterested(l:z);
    z=z+length(range);
    l = l+length(range);
end

clear z
clear l 

[~, column] = size(matrix);

TID= [];
% TID(:,1) = nematrix(:,1);
for i =  2:column
    TID(:,i) = (matrix(:,i-1)- (matrix(:,i)))./(matrix(:,i));
end

propertime = datetime(time,'ConvertFrom','posixtime'); %converts unix time to regular time which is used to find the nearest time stamp


timesinvecformat = datevec(propertime);
if (nargin == 5) %only if user specifies that a specific time and range is needed to be returned

    d = varargin{2};
    p = varargin{3};
    fromrange = varargin{1}(1);
    torange = varargin{1}(2);

    fromtime = datetime(d,'InputFormat','HH:mm:ss');
    fromtimevec = datevec(fromtime);
    z = find(timesinvecformat(:,4) == fromtimevec(:,4));
    [~, index3] = min(abs(timesinvecformat(z,:)-fromtimevec)); %find the nearest time stamp from the lower bound
    fromdate = z(index3(4));


    totime = datetime(p,'InputFormat','HH:mm:ss');
    totimevec = datevec(totime);
    e = find(timesinvecformat(:,4) == totimevec(:,4));
    [~, index4] = min(abs(timesinvecformat(e,:)-totimevec)); %find the nearest time stamp from the upper bound
    todate = e(index4(4));


    [~, index1] = min(abs(range-fromrange)); %find the nearest value of the lower bound for the range
    [~, index2] = min(abs(range-torange)); %find the nearest value of the upper bound for the range
    range = range(index1:index2);
    matrix = matrix((index1:index2),(fromdate:todate));
    TID = TID((index1:index2),(fromdate:todate));
    propertime = propertime(fromdate:todate);

elseif((nargin == 4) & class((varargin{1} == 'datetime'))) %return the matrix for the interval only if you include time interval for the entire range
  
    d = varargin{1};
    p = varargin{2};
    
    fromtime = datetime(d,'InputFormat','HH:mm:ss');
    fromtimevec = datevec(fromtime);
    z = find(timesinvecformat(:,4) == fromtimevec(:,4));
    [~, index3] = min(abs(timesinvecformat(z,:)-fromtimevec)); %find the nearest time stamp from the lower bound
    fromdate = z(index3(4));


    totime = datetime(p,'InputFormat','HH:mm:ss');
    totimevec = datevec(totime);
    e = find(timesinvecformat(:,4) == totimevec(:,4));
    [~, index4] = min(abs(timesinvecformat(e,:)-totimevec)); %find the nearest time stamp from the upper bound
    todate = e(index4(4));

    matrix = matrix(:,(fromdate:todate));
    TID = TID(:,(fromdate:todate));
    propertime = propertime(fromdate:todate);

elseif((nargin == 3) & class((varargin{1}(1)) == 'double')) %return the matrix for the specific range for all time stamps if time stamps is not included 
   
    fromrange = varargin{1}(1);
    torange = varargin{1}(2);
    [~, index1] = min(abs(range-fromrange)); %find the nearest value of the lower bound for the range
    [~, index2] = min(abs(range-torange)); %find the nearest value of the upper bound for the range
    matrix = matrix((index1:index2),:);
    TID = TID((index1:index2),:);
    
end

end
