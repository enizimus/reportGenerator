clear
clear classes 

report = latexGenerator;   % construct object
report.cleanDir            % clean the directory

report.addTitlePage        % title page   
report.addTableOfContents  % table of contents

% -------------------------------------------------------
report.addHeading('chapter','Introduction')
report.addParagraph('INTRODUCTION')

report.addParagraph('The following MATLAB code did the import of the text of the whole chapter:')
report.addMatlab({'report.addParagraph(''INTRODUCTION'')'},{'listing'}) 
% 
report.addParagraph('To ensure that Latex can be found by MATLAB the following lines have been added to {\tt startup.m}:')
% 
report.addMatlab({ ...
    'path1 = getenv(''PATH'');', ...
    'path1 = [path1,'':/Library/TeX/texbin''];', ...
    'setenv(''PATH'', path1)' ...
    },{'listing'})

% -------------------------------------------------------
report.addHeading('chapter','List Environment')

report.addParagraph('LIST')

report.addHeading('section','Itemize')

report.addList('itemize', { ...
    'Text 1', ...
    'Text 2', ...
    {'Text 3','','and some additional text.'} ...
    })

report.addParagraph('Listings can be nested:')

report.addList('itemize', { ...
    'Text 1', ...
    'Text 2', ...
    report.addList('itemize',{'Text a','Text b','Text c'}), ...
    'Text 3', ...
    report.addList('enumerate',{'Item a','Item b','Item c'}), ...
    'Text 4' ...
    })

report.addHeading('section','Enumerate')

report.addList('enumerate',{'Text 1','Text 2',{'Text 3','','Further text.'}})

report.addHeading('section','Description')

report.addList('description', {...
    {'Def 1:','Text 1','','And some further description.'}, ...
    {'Def 2:','Text 2'}, ...
    {'Def 3:','Text 3','','Further text.'} ...
    })

report.addParagraph('Here the first entry for each item is used to specify the name which is described.')

% -------------------------------------------------------
report.addHeading('chapter','Tabular and Table')

report.addHeading('section','A simple example')

report.addParagraph('A simple table from an array with standard settings:')

data_1 = [1,2,3;4,5,6];
report.addTabular(data_1);

report.addParagraph('A different format, alignment and labels for colums and rows.')
report.addParagraph('Different settings can be specified using the {\tt set} method:')
report.addMatlab({'report.set(''dataFormat'',''%i'')'},{'listing'}) 
report.addParagraph('If one would like to see the Latex output in the console one can use:')
report.addMatlab({'report.set(''dispLatexCode'',1)'},{'eval','listing'}) 

report.set('tableColLabels','col1,col2,col3')
report.set('tableRowLabels','row1,row2')
report.set('tableColumnAlignment','lccc')
report.set('dataFormat','%i')
report.addTabular(data_1);

report.addParagraph('To reset all table settings please use:')
report.addMatlab({'report.setDefault(''table'')'},{'eval','listing'}) 
report.addParagraph('To reset Latex output to its default value use:')
report.addMatlab({'report.setDefault(''dispLatexCode'')'},{'eval','listing'}) 

report.addHeading('section','Another example with booktabs and Not a Number')

data_2 = [1.12345 nan 3.12345; ...
    4.12345 5.12345 6.12345; ...
    7.12345 8.12345 9.12345; ...
    10.12345 11.12345 12.12345];
report.set('tableColumnAlignment','l|r|r')
report.set('dataNanString','nan')
report.set('dataFormat','%.4f,%.3f,%.2f')
report.addTabular(data_2);
report.setDefault('table') % reset

% Set column labels (use empty string for no label):
report.set('tableColLabels','col1,col2,col3')
% Set row labels (use empty string for no label):
report.set('tableRowLabels','row1,row2, ,row4')
report.set('dataFormat','%.2f,%.2f,%.2f')
report.set('booktabs',1)
report.addTabular(data_2)
report.setDefault('table') % reset


report.addHeading('section','MATLAB table as input')

report.addParagraph('Here the MATLAB table is constructed with the following code from {\tt myCodeBlocks.m}:')
report.addMatlab('TABLE_1',{'eval','listing'})

report.set('dataFormat','%i','tableColumnAlignment','l')
report.addTabular(T)

report.addHeading('section','Using a table instead of tabular')

report.set('transposeTable',1)
report.addTable(T,'My Caption')
report.setDefault('table') % reset

% -------------------------------------------------------
report.addHeading('chapter','Images and Figures')

report.addHeading('section','Code Listing and Evaluation')

report.addMatlab({'x=5; y=3;','z=x+y;','d=5;'},{'eval','listing'}) 
report.addMatlab({'myFigureCode.m'},{'eval','listing'}) 

report.addHeading('section','Image')
report.addParagraph('One of the above images directly here:')
report.addImage(fh(1))
report.set('imagePerLine',3,'imageOption','width=0.30\textwidth')
report.addImage(fh)
report.setDefault('image')

report.addHeading('section','Figure')
report.addParagraph('Two images side by side as a figure with caption:')
report.addFigure({fh(1),fh(3)},'Two images side by side')

report.addParagraph('All three images, one per line and modified width:')
report.set('imagePerLine',1,'imageOption','width=0.60\textwidth')
report.addFigure(fh,'One image per line')
report.setDefault('image')

% force latex to place all figures now
report.addParagraph('\clearpage')

% -------------------------------------------------------
report.addHeading('chapter','Pretty Output')

report.addHeading('section','Listing or Latex')

report.addMatlab( ...
    {'M1 = logical(eye(5));','M2 = logical(flipud(eye(5)));'}, ...
    {'eval','listing'})
report.addText('And so does it look like as listing')
report.addMatlabOutput({'M1','M2'})
report.addText('or in Latex mode')
report.addMatlabOutput({'M1','M2'},true)

report.addHeading('section','Graphics output for arrays')

report.addHeading('subsection','Two images in color with colorbar')

report.set('arrayImageColor',1,'arrayColorbar',1);
imageNames = report.createArrayImage({'M1','M2'});
report.setDefault('array')
report.set('dispLatexCode','1')
report.addFigure(imageNames,'My arrays separate')
report.setDefault('dispLatexCode')

report.addHeading('subsection','One image in bw without colorbar')

report.set('arrayImageColor',0,'arrayColorbar',0);
imageNames1 = report.createArrayImage({{'M1','M2'}});
report.setDefault('array')
report.addFigure(imageNames1,'My arrays together')

% -------------------------------------------------------
report.addHeading('subsection','Another example')

report.set('prettyComMax','inter','prettyMaxSize','[10,5]')
report.addMatlab({'R1 = rand(100);'},{'eval','listing'})
report.addText('And this is the output in form of a listing')
report.addMatlabOutput({'R1'})
report.addText('or again with latex syntax')
report.addMatlabOutput({'R1'},true)
report.addText('One can also display it as an image.')
report.setDefault('prettyComMax','prettyMaxSize')
report.set('arrayImageColor',1,'arrayColorbar',1);
report.set('imageOption','width=0.95\textwidth')

imageNames2 = report.createArrayImage({'R1'});
report.addFigure(imageNames2,'Some random numbers')

% -------------------------------------------------------
report.addHeading('chapter','Function description')

report.addHeading('section','A simple example')

myfunc = 'function [r1,r2] = func(i1,i2,i3)';
pre = 'Some text before. Write the following function with specified in- and output.';
typ = {'double','double','double','double','double'};
desc = {
    '2-D array', ...
    'Scalar', ...
    'Scalar', ...
    'Result 1', ...
    'Result 2' ...
    };
post = 'Some text after.';
report.addFunctionDescription(myfunc,typ,desc,pre,post)

report.addHeading('section','A complete example')

myfunc = 'myTestFunc.m';
pre = 'Schreiben sie die folgende Funktion mit dem in der Tabelle spezifizierten In- und Output.';
typ = {'double','logical','double','double'};
desc = {
    '2-dimensionale Matrix; quadratisch; alle Werte ungleich Null', ...
    'Stern in der gleichen Größe wie {\tt M} (siehe Beispiel)', ...
    'gleich wie {\tt M} aber mit Nullen wo {\tt L} {\tt false} ist (siehe Beispiel)', ...
    'Skalar; Summe aller Werte in {\tt M} wo {\tt L} {\tt true} ist' ...
    };
post = 'Die folgenden Beispiele erläutern die Aufgabe.';
report.addFunctionDescription(myfunc,typ,desc,pre,post)

report.addHeading('subsubsection','Beispiel 1 - $6\times 6$-Array')
report.addMatlab({ ...
    'M1 = reshape(1:36,6,6)+5;', ...
    '[L1,R1,r1] = myTestFunc(M1);' ...
    },{'eval','listing'})
report.addMatlabOutput({'M1','L1'})
report.addMatlabOutput({'R1','r1'})
report.set('arrayImageColor',0,'arrayColorbar',0);
report.set('imageOption','width=0.95\textwidth')
imageNames1 = report.createArrayImage({{'M1','L1','R1'}});
report.addFigure(imageNames1,'M1 (Links), L1 (Mitte), R1 (Rechts)')

report.addHeading('subsubsection','Beispiel 2 - $5\times 5$-Array')
report.addMatlab({ ...
    'M2 = reshape(1:25,5,5)+5;', ...
    '[L2,R2,r2] = myTestFunc(M2);' ...
    },{'eval','listing'})
report.addMatlabOutput({'M2','L2'})
report.addMatlabOutput({'R2','r2'})
imageNames2 = report.createArrayImage({{'M2','L2','R2'}});
report.addFigure(imageNames2,'M2 (Links), L2 (Mitte), R2 (Rechts)')
report.setDefault('array','image')

report.addHeading('section','Same example with information from help text of function')

myfunc = 'myTestFunc.m';
pre = 'Schreiben sie die folgende Funktion mit dem in der Tabelle spezifizierten In- und Output.';
post = 'Die folgenden Beispiele erläutern die Aufgabe.';
report.addFunctionDescription(myfunc,'','',pre,post)

report.addHeading('subsubsection','Beispiel 1 - $6\times 6$-Array')
report.addMatlab({ ...
    'M1 = reshape(1:36,6,6)+5;', ...
    '[L1,R1,r1] = myTestFunc(M1);' ...
    },{'eval','listing'})
report.addMatlabOutput({'M1','L1'})
report.addMatlabOutput({'R1','r1'})

report.addHeading('subsubsection','Beispiel 2 - $5\times 5$-Array')
report.addMatlab({ ...
    'M2 = reshape(1:25,5,5)+5;', ...
    '[L2,R2,r2] = myTestFunc(M2);' ...
    },{'eval','listing'})
report.addMatlabOutput({'M2','L2'})
report.addMatlabOutput({'R2','r2'})

% -------------------------------------------------------
report.addHeading('chapter','Some data processing')
report.addHeading('section','My Results')

dataDir = 'myDataDir';
dataPre = 'data_';
dataExt = '.txt';
blockPre = 'DATATEXT_';
dataTextBlock = [dataDir,filesep,'myDataTextBlocks.tex'];
textBlockStruct = report.readTextBlock(dataTextBlock);


dirList = dir([dataDir,filesep,dataPre,'*',dataExt]);
fileNames = {dirList.name};
for k = 1:numel(fileNames)
    fileName = [dataDir,filesep,fileNames{k}];
    data = load(fileName);
    figure;
    plot(data(:,1),data(:,2),'-r',data(:,1),data(:,3),'-b')
    xlim([min(data(:,1)),max(data(:,1))])
    ylim(ylim*1.2);
    xlabel('x')
    ylabel('y(x)')
    title(['Data source: ',fileName],'Interpreter','none')
    
    % underscore has to be escaped in latex
    printName = strrep(fileName,'_','\_');
    report.addHeading('subsection','Data') %['Data from ',printName])
    blockName = [blockPre,num2str(k)];
    if isfield(textBlockStruct,blockName)
        report.addParagraph(textBlockStruct.(blockName));
        %myText = strjoin(textBlockStruct.(blockName),blanks(1));
        %report.addParagraph(myText)
    end
    report.addImage(gcf)
end
    




% -------------------------------------------------------
report.addHeading('chapter','Final processing and viewing')

report.addText('Some commands to export, generate and view the results:')
report.addMatlab({ ...
    'report.export   % export latex file', ...
    'report.generate % process latex to pdf', ...
    'report.view     % viewer', ...
    'close all    % close all figures' ...
    },{'listing','eval'})


