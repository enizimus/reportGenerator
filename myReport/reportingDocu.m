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
report.addParagraph('TABTAB');   
report.addMatlab('TABFUN', {'listing', 'eval'});
report.addParagraph('TABTAB2');
report.addMatlab('TABFUN2', {'listing', 'eval'});
report.addParagraph('TABTAB3');
report.setDefault('table');
%report.addMatlab('TABFUN3', {'listing', 'eval'});







report.export;
report.generate;
report.cleanUp;
report.view;