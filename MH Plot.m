% group1.m
%this is a nice GUI that reads HDF5 files and pictorally displays the data
%with an adjustable color bar
function group1_plot
close all;
% global Files;
% global hfile;
Files = dir('mlh1807*.hdf5');
set(0,'DefaultAxesFontSize', 6, 'DefaultAxesTitleFontWeight', 'normal')
fig = figure();

% fig.Units = 'normalized'

popupFile = uicontrol('Style', 'popup',...
    'String', {Files(:).name},...
    'Position', [5 35 200 50], ...
    'Callback', @updateFile);

N = 1;
path_h5 = fullfile(Files(N).folder,Files(N).name)
hfile = h5explore(path_h5);
ExperimentNames = fieldnames(hfile.Data.Array_Layout);

popupExp = uicontrol('Style', 'popup',...
    'String', ExperimentNames,...
    'Position', [215 35 400 50],...
    'Callback', @updateExperiment);



Experiment = hfile.Data.Array_Layout.(ExperimentNames{1});
range = Experiment.range;
timestamps = datetime(Experiment.timestamps,'convertfrom','posixtime');

X2DFields = fieldnames(Experiment.X2D_Parameters);
X2DFields(strcmp(X2DFields,'Data_Parameters')) = [];
X1DFields = fieldnames(Experiment.X1D_Parameters);
X1DFields(strcmp(X1DFields,'Data_Parameters')) = [];
X1DFields{end+1} = 'range';
N2D = 1;
% %             MnNames = strline(Experiment.X2D_Parameters.Data_Parameters.mnemonic');
% MnNames = Experiment.X2D_Parameters.Data_Parameters.mnemonic';
% MnNames(regexp(MnNames(:)','[^a-zA-Z0-9 \n0]{1}')) = '_';
% %             MnNames
% MnNames = strline(MnNames);
% DescNames = strline(Experiment.X2D_Parameters.Data_Parameters.description');
% cellfun(@(n) n(regexp(n,'[\w ]')),strline(Experiment.X2D_Parameters.Data_Parameters.mnemonic'),'uniformoutput',false)
% X2DLabels = strline([Experiment.X2D_Parameters.Data_Parameters.mnemonic',Experiment.X2D_Parameters.Data_Parameters.description'])
if isfield(Experiment.X1D_Parameters,'gdalt')
    range =  Experiment.X1D_Parameters.gdalt;
end

popup2D = uicontrol('Style', 'popup',...
    'String', X2DFields,...
    'Position', [215 0 400 50],...
    'Callback', @update2D);

popup1D = uicontrol('Style', 'popup',...
    'String', X1DFields,...
    'Position', [15 0 200 50],...
    'Callback', @update1D);

sld = uicontrol('Style', 'slider',...
    'Min',-2,'Max',2,'Value',0,...
    'Position', [620 35 120 20],...
    'Callback', @drawplot);
holdbox = uicontrol('Style','checkbox',...
    'Position',[620 15 10 10],...
    'Callback',@drawplot);


    function updateFile(src,event)
        NF = popupFile.Value;
        path_h5 = fullfile(Files(NF).folder,Files(NF).name)
        hfile = h5explore(path_h5);
        ExperimentNames = fieldnames(hfile.Data.Array_Layout);
        popupExp.String = ExperimentNames;
        popupExp.Value = 1;
        updateExperiment(src,event);
    end
    function updateExperiment(src,event)
        NE = popupExp.Value;
        Experiment = hfile.Data.Array_Layout.(ExperimentNames{NE});
        range = Experiment.range;
        timestamps = datetime(Experiment.timestamps,'convertfrom','posixtime');
        X2DFields = fieldnames(Experiment.X2D_Parameters);
        X2DFields(strcmp(X2DFields,'Data_Parameters')) = [];
        popup2D.String = X2DFields;
        X1DFields = fieldnames(Experiment.X1D_Parameters);
        X1DFields(strcmp(X1DFields,'Data_Parameters')) = [];
        X1DFields{end+1} = 'range';
        popup1D.String = X1DFields;
        update2D(src,event);
    end
    function update2D(src,event)
        N2D = popup2D.Value;
        
        
        
        update1D(src,event);
    end
    function update1D(src,event)
        N1D = popup1D.Value;
        %         ArraySize = size(Experiment.X2D_Parameters.(X2DFields{N2D})');
        %         if strcmpi('range',X1DFields{N1D})
        
        range = Experiment.range;
        %         else
        
        %             range =  Experiment.X1D_Parameters.(X1DFields{N1D});
        %         end
        
        drawplot
    end
    function drawplot(src,event)
        size(timestamps)
        size(range)
        size(Experiment.X2D_Parameters.(X2DFields{N2D})')
        if holdbox.Value
            hold on
        else
            
            cla;
            hold on
        end
        h = surface(timestamps,range,Experiment.X2D_Parameters.(X2DFields{N2D})');
        plot(datetime(2018,07,24,8,57,0)+[0,0],[min(range),max(range)],'k','linewidth',2)
        set(h,'edgecolor','none');view([0,0,1]);axis tight;
        colormap jet
        colorbar
        cscale = sld.Value;
        crange = (1*(10.^cscale)).*std(Experiment.X2D_Parameters.(X2DFields{N2D})(:),'omitnan');
        cmean = median(Experiment.X2D_Parameters.(X2DFields{N2D})(:),'omitnan');
        caxis([-crange+cmean,crange+cmean])
    end


end
