% processResults_CorticalRegMethods
% Ali Farooq analysis

% Import results from Excel sheet
Folder  = 'C:\Users\AliFarooq\Desktop\New folder';
File    = 'Combined Results JP_v2.xlsx';
importExcelResults;

%Check the imported data table. See how the variable names were imported.
head(CombinedResults);

% Process results. Select the variable name to be analyzed.
variableName        = 'CtThmm';
variableNameForPlot = 'Ct.Th [mm]';

%% Figure
figure('Units', 'pixels', ...
    'Position', [100 100 800 475]);
hold on;

% Extract the results for the variable Subregion = "Vertical_Cortex"
rows   =  CombinedResults.Subregion == "Vertical_Cortex";
T      =  CombinedResults(rows, :);
%Create BoxPlot
Y      =  eval(['T.'  variableName]);
hBxp   =  boxplot(Y, T.Method, 'symbol', '+', 'Color', 'k');

[C, ~, ic] = unique([T.Method],'stable');

% Plot the data
hScp   =  scatter(ic, Y, 'filled','MarkerFaceAlpha',0.8','jitter','on','jitterAmount',0.1);
hold off

%% Figure settings
strinY = ['$$ ' variableNameForPlot ' $$'];
ylabel(strinY,'FontSize',24, 'Interpreter','latex')
strinX = '$$ Method $$';
xlabel(strinX,'FontSize',24, 'Interpreter','latex')

ylow  = min(Y) - 0.1*min(Y);
yhigh = max(Y) + 0.1*max(Y);
ylim([ylow-0.05 yhigh]);
yinc  = round( (yhigh-ylow)/5, 2);
ytickformat('%.3f')  % Change the format of the ticks according to the variable being plotted!
set(hScp,'SizeData', 75);
set(hBxp,'linewidth',5);
set(gca, ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02] , ...
    'XMinorTick'  , 'off'      , ...
    'YMinorTick'  , 'on'      , ...
    'YGrid'       , 'on'      , ... %'XTick'       , xlow:xinc:xhigh, ...
    'XColor'      , [.3 .3 .3], ...
    'YTick'       , ylow:yinc:yhigh, ...
    'YColor'      , [.3 .3 .3], ...
    'FontSize'    , 24, ...
    'LineWidth'   , 2 );

%% Use export_fig to create good quality figures from the plots
 export_fig('filename', [ variableName '.png'], '-png', '-opengl');
 set(gcf, 'PaperPositionMode', 'auto');
 print -depsc2 CtThmm.eps
  
%% Statistical Analysis
% Analysis of Variance: Anova for Ct.Th
[p,t,stats] = anova1(Y, T.Method, 'off');
%[c,m,~,nms] = multcompare(stats);

% Analysis of paired ttest. 
% Extract the results for the three different methods
rowsMethod1 = CombinedResults.Method == "Manual";
rowsMethod2 = CombinedResults.Method == "Mask";
rowsMethod3 = CombinedResults.Method == "Mesh";
subTable1   = CombinedResults(rows & rowsMethod1, :);
subTable2   = CombinedResults(rows & rowsMethod2, :);
subTable3   = CombinedResults(rows & rowsMethod3, :);

if p < 0.05
    [hTestA, pTestA] = ttest(subTable1.CtThmm, subTable2.CtThmm);
    [hTestB, pTestB] = ttest(subTable1.CtThmm, subTable3.CtThmm);
    [hTestC, pTestC] = ttest(subTable2.CtThmm, subTable3.CtThmm);
    
    % ToDo: Check for which pair there were significant differences, check pTest
    
else
   %'do nothing'; 
end



