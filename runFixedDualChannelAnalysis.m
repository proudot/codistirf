% restoredefaultpath;
% addpath(genpath('/project/shared/danuser_schmid/MATLAB-COMMANDLastGitVersion/'));

% try 
%     parpool
% catch
% end

%% Data copy for testing purposes
clear all
origData='/project/bioinformatics/Danuser_lab/shared/proudot/CME/fixCellAlignement/package/data/';
dpath = '/tmp/testPrysmExport/'; 
if(exist(dpath)) rmdir(dpath,'s'); end;
mkdirRobust(dpath);
copyfile(origData,dpath);

%% COLLECT AND ORGANIZE DATA
% Find every path that respect [dpath '/17*/'] to define experiment path
XPFolderWildcard='171122.*';   % "." means any given character; "*" means repeated anytime.
% In the experiment folder, look for condition in folder <conditionFolderNames>
conditionFolderNames={'EGF','Akti','ERKi','Starvation'};
% In the experiment folder, look for movie that match <movieDescriptor>
movieDescriptor='Cell{m}_{ch}.TIF'; % movie 
% where {ch} describe the channel strings <channelDescriptor>
channelDescriptor={'w1561-TIRF','w2642-TIRF'};

%% RUN COMPUTATION AND DISPLAY
channelNamesForDisplay={'APPL1','APPL2'};
conditioNamesForDisplay={'EGF','Akti','ERKi','Starvation'};

% Other input
fluorophores={'EGFP','mCherry'};

% Create a  structure <experiments> that collects each movie data sorted by conditions and experiments
candidateDir=dir(dpath);
xpFolderDir=candidateDir(arrayfun(@(f) ~isempty(regexp(f.name,XPFolderWildcard)), candidateDir));
xpFolderPath=arrayfun(@(d) fullfile(dpath,d.name), xpFolderDir,'unif',0);
experiments=[];
for xpIdx=1:length(xpFolderPath)
    experimentData.folderPath=xpFolderPath{xpIdx};
    experimentData.conditions=[];
    for cIdx=1:length(conditionFolderNames)
        sortImgFileByMovieAndChannel([xpFolderPath{xpIdx} filesep conditionFolderNames{cIdx} filesep movieDescriptor],'channelDescriptor',channelDescriptor);
        conditionData.movies = loadConditionData([xpFolderPath{xpIdx}  filesep conditionFolderNames{cIdx}  ],{'ch_1','ch_2'},fluorophores,'MovieSelector','movie_');
        experimentData.conditions=[ experimentData.conditions conditionData];
    end
    experiments=[experiments experimentData];
end



% Batch process all movies  
all_data= arrayfun(@(xp) [xp.conditions.movies],experiments,'unif',0);
all_data=[all_data{:}];
rehash;tic;
runDistFromCellEdgeIF(all_data,'Overwrite',false,'DisplayPlot',false,'Name', 'allData','ChannelNames',channelNamesForDisplay);
toc;

% For each condition: print profiles and cell RGB images grouped in their respective folder.
for xpIdx=1:length(experiments)
    for cIdx=1:length(experiments(xpIdx).conditions)
            edgeDistStats=runDistFromCellEdgeIF(experiments(xpIdx).conditions(cIdx).movies,'Overwrite',false,...
            'Name',conditioNamesForDisplay{cIdx},'DisplayPlot',false,'ChannelNames',channelNamesForDisplay);
            experiments(xpIdx).conditions(cIdx).edgeDistStats=edgeDistStats;
    end
end

%% Export count and intentisty to a prysm-compatible file on a per-experiment basis.
for xpIdx=1:numel(experiments)
    prysmFile=fullfile(experiments(xpIdx).folderPath,'prysmFile.xls');
    exportDistFromCellEdgeIFToPrysm(prysmFile,{experiments(xpIdx).conditions.edgeDistStats},'conditionNames',conditioNamesForDisplay,'channelNames',channelNamesForDisplay)
end


%% Show results only for first condition
runDistFromCellEdgeIF(experiments(1).conditions(1).movies,'Overwrite',false,'DisplayPlot',true,'Name',conditioNamesForDisplay{1},'ChannelNames',channelNamesForDisplay);


