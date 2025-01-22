function fileName = createOutputFile(subjectNumber, directory, suffix, format)
% create file name for subject's data
if (nargin<4); format = 'mat'; end
if (nargin<3); suffix = ''; end
if ~isempty(suffix)
    suffix = ['_' suffix];
end
if ~exist(directory, 'dir')
    mkdir (directory)
end
tym = strsplit(datestr(now,'ddmm.HHMM'),'.');
prefix = [directory, filesep, num2str(subjectNumber),'_(' tym{1} '_' tym{2} ')'];
count = 1;
fileName = [prefix suffix '.' format];
pwd=cd(directory);
while exist(fileName)
    count = count+1;
    fileName = [prefix suffix '(' num2str(count) ').' format];
end
cd(pwd);
end
