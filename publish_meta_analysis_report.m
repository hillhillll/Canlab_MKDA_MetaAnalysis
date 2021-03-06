% Runs batch analyses and publishes HTML report with figures and stats to
% results/published_output in local study-specific analysis directory.

% Run this from the main mediation results directory (basedir)

close all
warning off, clear all, warning on 

resultsdir = pwd;

fprintf('Creating HTML report for results in:\n%s\n', resultsdir);

% ------------------------------------------------------------------------
% Check that we have a valid MKDA Meta_activationFWE results dir
% ------------------------------------------------------------------------

is_mediation_dir = exist(fullfile(resultsdir, 'MC_Info.mat'));
%is_run = exist(fullfile(resultsdir, 'X-M-Y_effect.img'));

if ~is_mediation_dir
    fprintf('%s\nis not a MKDA meta-analysis directory because MC_Info.mat is missing.\nSkipping report.\n', resultsdir);
    return
end

% if ~is_run
%     fprintf('Mediation does not appear to have run correctly because X-M-Y_effect.img is missing.\nSkipping report.\n');
%     return
% end

% ------------------------------------------------------------------------
% Set HTML report filename and options
% ------------------------------------------------------------------------

pubdir = fullfile(resultsdir, 'published_output');
if ~exist(pubdir, 'dir'), mkdir(pubdir), end

pubfilename = ['MKDA_meta_analysis_report_' scn_get_datetime];

p = struct('useNewFigure', false, 'maxHeight', 800, 'maxWidth', 1600, ...
    'format', 'html', 'outputDir', fullfile(pubdir, pubfilename), 'showCode', false);

            % move old reports to 'older' dir
            move_old_reports(pubdir, pubfilename)

% ------------------------------------------------------------------------
% Run and report status
% ------------------------------------------------------------------------

publish('Meta_results_batch_script.m', p);

myhtmlfile = fullfile(pubdir, pubfilename, 'Meta_results_batch_script.html');

if exist(myhtmlfile, 'file')
    
    fprintf('Saved HTML report:\n%s\n', myhtmlfile);
    
    web(myhtmlfile);
    
else
    
    fprintf('Failed to create HTML report:\n%s\n', myhtmlfile);
    
end






function move_old_reports(pubdir, pubfilename)

olddir = fullfile(pubdir, 'OLDER_REPORTS');
if ~exist(olddir, 'dir'), mkdir(olddir); end

myreportwildcard = [pubfilename(1:end - 17) '*'];

oldfiles = dir(fullfile(pubdir, myreportwildcard));

if length(oldfiles) > 1
    fprintf('Moving old reports named %s to OLDER_REPORTS folder.\n', myreportwildcard);
end

for i = 1:length(oldfiles)
    
    myfile = fullfile(pubdir, oldfiles(i).name);
    [SUCCESS,MESSAGE,MESSAGEID] = movefile(myfile, olddir);
    
end

end
