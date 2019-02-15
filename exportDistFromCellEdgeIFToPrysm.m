function [intTable,intTableNorm,countTable,countTableNorm]=exportDistFromCellEdgeIFToPrysm(filename,edgeDistStats,varargin)
% Export stats for prysm
% usage: TODO
% PR 2018
ip = inputParser;
ip.CaseSensitive = false;
ip.addRequired('filename');
ip.addRequired('edgeDistStats');
ip.addParameter('ChannelNames','ch01', @(x) (ischar(x)||iscell(x)));
ip.addParameter('ConditionNames','cond01', @(x) (ischar(x)||iscell(x)));
ip.parse(filename,edgeDistStats,varargin{:});
p=ip.Results;

if(~iscell(edgeDistStats))
    edgeDistStats={edgeDistStats};
end

conditionNames=p.ConditionNames;
if(~iscell(conditionNames))
    conditionNames={conditionNames};
end

ChannelNames=p.ChannelNames;
if(~iscell(ChannelNames))
    ChannelNames={ChannelNames};
end

if(numel(ChannelNames)~=numel(edgeDistStats{1}.dfeHistsNorm))
    ChannelNames=arrayfun(@(c) sprintf('Ch%0d',c),1:numel(edgeDistStats{1}.dfeHistsNorm),'unif',0);
end

if(numel(conditionNames)~=numel(edgeDistStats))
    conditionNames=arrayfun(@(c) sprintf('Cond%0d',c),1:numel(numel(edgeDistStats)),'unif',0);
end

nCond=length(edgeDistStats);
nCh=numel(ChannelNames);

AllCondStatTable=cell(4,nCond,nCh);
statNames={'count','normCount','int','normInt'};

% condNameRepCell={};

for cIdx=1:length(edgeDistStats)
    out=edgeDistStats{cIdx};
    xv=out.distBins;
    for chIdx=1:nCh
        AllCondStatTable(1,cIdx,:)=createStatTables(xv,out.dfeHists,ChannelNames);
        AllCondStatTable(2,cIdx,:)=createStatTables(xv,out.dfeHistsNorm,ChannelNames);
        AllCondStatTable(3,cIdx,:)=createStatTables(xv,out.ampHists,ChannelNames);
        AllCondStatTable(4,cIdx,:)=createStatTables(xv,out.ampHistsNorm,ChannelNames);
    end
    AllCondStatTable(:,cIdx,:)=cellfun(@(t) prefixVariable(t,conditionNames{cIdx}),AllCondStatTable(:,cIdx,:),'unif',0);
end

% Write in an excel file, a condition and channel per sheet for easier copy
% pasting.
[folder,name,ext]=fileparts(filename);
warning('off','MATLAB:xlswrite:AddSheet')
for sIdx=1:length(statNames)
    sfilename=fullfile(folder,[name '-' statNames{sIdx} ext]);
    book = matlab.io.spreadsheet.internal.createWorkbook('xls',[], true);
    book.save(sfilename)
    for condIdx=1:nCond
        for chIdx=1:nCh
            writetable(AllCondStatTable{sIdx,condIdx,chIdx},sfilename,'Sheet',[conditionNames{condIdx} '-' ChannelNames{chIdx}]);
        end
    end
end

function T=prefixVariable(T,pref)
    T.Properties.VariableNames(2:end)=cellfun(@(n) [pref '_' n], T.Properties.VariableNames(2:end),'unif',0);


function statTableCell=createStatTables(bins,statCell,cellName)

    chIdx=1:numel(statCell);
    statTableCell=cell(1,numel(chIdx));


    for c = chIdx
            %% Create 4 tables: Int, raw int, count, rawCount
            chName=cellName{c};

            cStateTable=array2table(statCell{c}',...
                'VariableNames',arrayfun(@(i) sprintf('%s_Cell_%0d',chName,i),1:size(statCell{c},1),'unif',0));
            cStateTable.dist=bins(1:height(cStateTable))';
            cStateTable=cStateTable(:,[end 1:(end-1)]);
            statTableCell{c}=cStateTable;

            % if(isempty(statTable))
            %     statTable=cStateTable;
            % else
            %     statTable=join(statTable,cStateTable,'Keys','dist');
            % end
    end


function condTable=joinCondTable(condTableCell,condNames)
        for c = 1:numel(condTableCell)
                    condTableCell{c}.Properties.VariableNames(2:end)=cellfun(@(n) [condNames{c} '_' n], condTableCell{c}.Properties.VariableNames(2:end),'unif',0);
        end
        condTable=condTableCell{1};
        for c = 2:numel(condTableCell)
            condTable=innerjoin(condTable,condTableCell{c},'Keys','dist');
        end

