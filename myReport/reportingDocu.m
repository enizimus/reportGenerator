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
               'Latexmk package','Ruby framework (on windows)'});
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

report.addNewPage;
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
report.addMatlab('FIBOFUN', {'listing', 'eval'});

report.export;
report.generate;
report.cleanUp;
report.view;