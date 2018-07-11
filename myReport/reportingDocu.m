clear 
clear classes
close all
clc

% initializing the latexGenerator object
report = latexGenerator;
% cleaning the directory of old files
report.cleanDir;


report.addTitlePage;
report.addTableOfContents;

% INTRODUCTION --------------------------------------
report.addHeading('chapter', 'Introduction');
report.addHeading('section', 'About this toolset');

report.addParagraph('ABOUT');
report.addHeading('section', 'Setup');

% SETUP ---------------------------------------------
report.addParagraph('SETUP1');
report.addList('itemize', {'\LaTeX{} distribution for your system',...
               'Latexmk package','Ruby framework (if the right files dont get installed with Latexmk)'});
report.addParagraph('SETUP2');

report.addHeading('section', 'How it works');
report.addParagraph('HOWIW');

report.addHeading('chapter', '\LaTeX Generator')
report.addParagraph('TEXINTRO');

% NEW REPORT -----------------------------------------
report.addHeading('section', 'New report');
report.addParagraph('NEWREPORT1');
report.addMatlab('report = latexGenerator;', 'listing');
report.addParagraph('NEWREPORT2');
report.addMatlab('report = latexGenerator(''settingFile'', ''personalSettings.dat'');', 'listing');

% DELETING FILES -------------------------------------

report.addHeading('section', 'Deleting files');
report.addParagraph('DELETEFILES');

report.addList('itemize', {['{\tt report.cleanDir;} cleans all files that could cause a conflict, '...
    'use it just after creating the {\tt latexGenerator} object'],['{\tt report.cleanDir({''pdf'',''tex''})} '...
    'this won''t delete the generated .pdf and .tex files, could be used at the end to avoid having many '...
    'not needed files in your working space'], '{\tt clearMediaDir} will clean the media directory'});

% SET AND GET ----------------------------------------
report.addHeading('section', 'Set and Get');
report.addParagraph('SETGET1');
report.addMatlab('report.set(''mediaPrefix'', ''plot_'')','listing');
report.addParagraph('SETGET2');

% TITLE AND TOC --------------------------------------
report.addHeading('section', 'Title page and TOC');
report.addParagraph('TITLETOC');
report.addMatlab({'report.addTitlePage','report.addTableOfContents'}, 'listing');

% PARAGRAPHS -----------------------------------------

report.addHeading('section', 'Paragraphs');
report.addParagraph('PARAGRAPH');
report.addMatlab('report.addParagraph(''This is an example sentence'')',{'listing', 'eval'});

% HEADINGS -------------------------------------------
report.addHeading('section', 'Headings');
report.addParagraph('There are several types of headings which can be added :');
report.addList('itemize',{'part', 'chapter', 'section', 'subsection', 'subsubsection'});
report.addParagraph('HEADINGS');
report.addMatlab('report.addHeading(''section'', ''Headings'')','listing');

% LISTS ----------------------------------------------

%report.addNewPage;
report.addHeading('section', 'Lists');
report.addParagraph('There are two types of lists you can generate through MATLAB :');
report.addList('itemize', {'itemize','enumerate','description'});
report.addParagraph('This list was created with the following code :');
report.addMatlab('report.addList(''itemize'', {''itemize'',''enumerate'',''description''});','listing');
report.addParagraph('LISTSENV');
report.addList('itemize', {'Item 1', ...
                           report.addList('enumerate', {'Enum 1', 'Enum2', 'Enum3'}),...
                           'Item 2', ...
                           report.addList('itemize', {'Item 2.1', 'Item 2.2'}),...
                           'Item 3', ...
                           report.addList('description', ...
                           {{'Definition 1 : ', 'Text 1'}, ...
                           {'Definition 2 : ', 'Text2 ', 'Some more text'}})});
       
% TABULAR, TABLE -------------------------------------

report.addHeading('section','Tabular and table');
report.addHeading('subsection','Tabular');
report.addParagraph('TABTAB');   
report.addMatlab('TABFUN', {'listing', 'eval'});


report.addParagraph('TABTAB2');
report.set('dataFormat','%i');
report.addMatlab('TABFUN2', {'listing'});
report.addMatlab('TABFUN21', {'eval'});
report.addParagraph('TABTAB3');
report.setDefault('table');

report.addMatlab('TABFUN3',{'listing'});
report.set('dataFormat','%0.1f,%0.3f,%0.1f,%0.2f');
report.addMatlab('TABFUN31',{'eval'});

report.setDefault('table');
report.set('dataFormat', '%.3f');
report.addParagraph('TABTAB4');
report.addMatlab('TABFUN4', {'listing', 'eval'});
report.addParagraph('TABTAB41');
report.addMatlab('TABFUN5', {'listing', 'eval'});
report.addParagraph('TABTAB42');

report.addHeading('subsection','Table');
report.addParagraph('TABTAB5');
report.setDefault('table');
report.set('dataFormat', '%i,%.02f,%.02f');
report.addMatlab('TABFUN6', {'listing', 'eval'});
report.addParagraph('TABTAB51');
report.addMatlab('TABFUN7',{'listing', 'eval'});

% FIGURES --------------------------------------------

report.addNewPage;
report.setDefault('image');
report.addHeading('section', 'Images and Figures');
report.addParagraph('FIGS');
report.addMatlab('FIGFUN', {'listing', 'eval'});
report.addParagraph('FIGS2');
report.addMatlab('report.addImage(figh(1));', {'listing', 'eval'});
report.addParagraph('FIGS3');
report.addMatlab('FIGFUN2', {'listing', 'eval'});
report.setDefault('image');
report.addMatlab('FIGFUN3', {'listing', 'eval'});
report.addParagraph('FIGS4');
report.addMatlab('FIGFUN4', {'listing', 'eval'});
report.addParagraph('\clearpage')
report.addParagraph('FIGS5');

% MATLAB ---------------------------------------------

report.addHeading('section', 'Pretty output');
report.addHeading('subsection', 'Listing and Latex');
report.addParagraph('PRETTY');
report.addMatlab('PRETTYFUN',{'listing', 'eval'}, 0, 1, 3);
report.addText(['If we use want the MATLAB console output we will use the '...
    'following function and pass the variable names as a cell array of strings']);
report.addMatlab('PRETTYFUN',{'listing', 'eval'}, 0, 4, 5);
report.addText(['If we want the same variables displayed but in latex mode '...
    'then we will use the following syntax']);
report.addMatlab('PRETTYFUN',{'listing', 'eval'}, 0, 6, 7);
report.addText(['Now with a different collor, standard black is also possible']);
report.addMatlab('PRETTYFUN',{'listing', 'eval'}, 0, 8, 12);

report.addHeading('subsection', 'Big matrices');
report.addParagraph('PRETTY1');
report.addMatlab('PRETTYBIG', {'listing','eval'}, 0, 1, 4);
report.addNewPage;
report.addText('Or if we want it in latex style, this time in black color');
report.addMatlab('PRETTYBIG', {'listing','eval'}, 0, 5, 8);

report.addHeading('subsection', 'Graphic output for arrays');
report.addParagraph('PRETTY2');
report.addMatlab('PRETTYFUN',{'listing', 'eval'}, 0, 13, 18);
report.addNewPage;
report.addParagraph('PRETTY3');
report.addMatlab('PRETTYFUN',{'eval'}, 0, 19, 20);
report.addMatlab('PRETTYFUN',{'listing', 'eval'}, 0, 21, 25);

report.addParagraph('PRETTY4');
report.addMatlab('PRETTYBIG', {'listing', 'eval'}, 0, 8, 13);
report.addParagraph('PRETTY5');
report.addMatlab('MAGICFUN', {'listing', 'eval'});
report.setDefault('image', 'table');

% FUNCTIONS ------------------------------------------

report.addHeading('section', 'Function descriptions');
report.addParagraph('FUNPART');
report.addMatlab('FUNFUNC',{'listing', 'eval'});
%report.addMatlab('MATFUN', {'eval'});
myfun = 'matFun.m';
pre = 'The type and description can also be extracted from the MATLAB help output for that function';
post = 'Just by passing empty strings for {\tt type} and {\tt desc} it will get the data from the help output';
report.addFunctionDescription(myfun,'','',pre,post);
report.addParagraph('FUNPART2');
report.addMatlab('matFun.m', {'listing'});

% EQUATIONS ------------------------------------------

report.addHeading('section', 'Equations');
report.addParagraph('EQNS');
report.addMatlab('EQNS', {'eval'});
report.addText('Or enumerated');
report.addEquation({'cos(x)^2 = \frac{1}{2}(1+cos(2x))'}, 'equation');
report.addNewPage;
% ZIPPING --------------------------------------------

report.addHeading('section','Zip project files');
report.addParagraph('ZIPPING');
report.addMatlab('report.zipFiles(''myZippedFiles'');','listing')


% EXPORT ---------------------------------------------

report.addHeading('section', 'Generating and viewing');
report.addParagraph('LASTSTP');
report.addList('itemize', {'{\tt start [filename]} (Windows)', '{\tt open [filename]} (MAC OS)',...
    '{\tt xdg-open [filename]} (Linux)'});
report.addParagraph('LASTSTP2');


% TEMPLATE -------------------------------------------

report.set('textBlockFile', 'chapter_three');
report.addHeading('chapter', 'Template');
report.addParagraph(['You can find a template project directory provided, {\tt reportTemplate}, the following files can be found in it and can be edited to fit your needs.']);

report.addText('-{\tt mainMatlab.m : }main MATLAB file which holds the code that ties everything together, please note that it is not necessary to do everything inside of this template, the only thing that is important is to have all of the files necessary at the right places, that is why we made this template. The main advantage of such a tool is that you use it in projects where you need a self generating report, it sure helps avoiding manually typing the data every time we maybe change some parameters.');
report.addText(['-{\tt setting.dat : }is a file which you need in every project because it holds all of the important parameters and settings for the programs to work, you can adjust it to your liking just as the other files by directly changing it or by using the {\tt set} function.']);
report.addText('-{\tt myTextBlocks.tex : }is a .tex file which is used to hold blocks of plain text or specific latex syntax, which you can access using the {\tt %% TAG} identifiers as shown in the previous chapter');
report.addText('-{\tt myMatlabBlocks.m : }is a .m file which holds MATLAB code that is also separated with the {\tt %% TAG} identifiers and we can use them to access this code, list it and evaluate it, for examples please reffer to the previous chapter');
report.addText('-{\tt myMatlabInit.m : }MATLAB init file, gets executed at the start, you can specify project dependant settings like the style of MATLAB figures');
report.addText('-{\tt startup.m : }MATLAB startup file, needs to have the path to latexmk replaced with the path on your machine, it is needed to add this path to the MATLAB search path it is not neccessary to use this file for that');

report.export;
report.generate;
report.cleanDir({'pdf'});
report.view;
close all;