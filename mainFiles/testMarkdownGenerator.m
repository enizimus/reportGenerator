clear
clear classes 


obj = markdownGenerator;
obj.cleanDir

obj.addTitlePage
% obj.addTableOfContents
% 
obj.addHeading('chapter','Ein Kapitel')
obj.addHeading('section','Mit Numerierung')

obj.addParagraph('TEXT1')
obj.addParagraph('TEXT2')

obj.addList('itemize',{'Text 1','Text 2',{'Text 3','und so weiter.'}})
obj.addList('enumerate',{'Text 1','Text 2',{'Text 3','und so weiter.'}})
obj.addList('description',{{'Def 1:','Text 1'},{'Def 2:','Text 2'},{'Def 3:','Text 3','und so weiter.'}})

obj.addList('itemize', { ...
    'Text 1', ...
    'Text 2', ...
    obj.addList('enumerate',{'a','b','c'}), ...
    'Text 3' ...
    })


% 
% % obj.addList('itemize', {})
% 
% 
% obj.addHeading('section','Tabular and Table')
% 
% 
% obj.set('dispLatexCode','1')
% 
data_1 = [1,2,3;4,5,6];
obj.set('tableColLabels','col1,col2,col3')
obj.set('tableRowLabels','row1,row2')
obj.set('transposeTable',1)
obj.addTabular(data_1);
obj.setDefault('table') % reset



% 
data_2 = [1.12345 nan 3.12345; ...
    4.12345 5.12345 6.12345; ...
    7.12345 8.12345 9.12345; ...
    10.12345 11.12345 12.12345];
%obj.set('tableColumnAlignment','l|r|r')
obj.set('dataNanString','nan')
% obj.set('dataFormat','%.2f,1,%.1f,2')
obj.set('dataFormat','%.2f,%.1f,%.1f')
%obj.set('booktabs',1)
obj.addTabular(data_2);
obj.setDefault('table') % reset
% 
% 
% % Set column labels (use empty string for no label):
% obj.set('tableColLabels','col1,col2,col3')
% % Set row labels (use empty string for no label):
% obj.set('tableRowLabels','row1,row2, ,row4')
% obj.set('dataFormat','%.2f,%.1f,%.1f')
% obj.set('tableColumnAlignment','l|r|r|r')
% obj.addTabular(data_2)
% obj.setDefault('table') % reset
% 
% 
% % LastName = {'Smith';'Johnson';'Williams';'Jones';'Brown'};
% % Age = [38;43;38;40;49];
% % Height = [71;69;64;67;64];
% % Weight = [176;163;131;133;119];
% % T = table(Age,Height,Weight,'RowNames',LastName);
% 
obj.addMatlab('TABLE_1','eval')
% 
% 
obj.set('dataFormat','%i','tableColumnAlignment','l')
obj.addTable(T,'From Matlab Table')
% 
obj.set('transposeTable',1)
obj.addTabular(T)
% obj.addTable(T,'My Caption')
obj.setDefault('table') % reset
% 
% 
% 
% 
% obj.setDefault('dispLatexCode')
% 
% 
% 
% 
% obj.addHeading('section*','Ohne Numerierung')
% 
% 
obj.addText('Code Listing.',1)
obj.addMatlab({'x=5; y=3;','z=x+y;','d=5;'},{'eval','listing'}) 
obj.addMatlab({'myFigureCode.m'},{'eval','listing'}) 
% 
obj.addImage({'test_1.png',fh(3)})

obj.set('imagePerLine',1)
% obj.addImage({'test_1.png',fh(3)})
obj.addFigure({'test_1.png',fh(3)},'Mixed')
% 
% 
% 
% obj.set('imagePerLine',1,'imageOption','width=0.60\textwidth')
% obj.addFigure(fh,'My Caption')
% 
obj.addHeading('section','Pretty Output')

obj.addMatlab({'M1 = logical(eye(5));','M2 = logical(flipud(eye(5)));'},{'eval','listing'})
obj.addText('Und so schaut es dann aus.')
obj.addMatlabOutput({'M1','M2'},true)

obj.set('arrayImageColor',0,'arrayColorbar',0);
imageNames = obj.createArrayImage({{'M1','M2'}});
obj.setDefault('array')
% 
obj.set('dispLatexCode','1')
obj.addFigure(imageNames,'My Arrays')
obj.addImage(imageNames)
obj.setDefault('dispLatexCode')
% 
% 
% 
% 
obj.set('prettyComMax','inter','prettyMaxSize','[10,5]')
obj.addMatlab({'R1 = rand(10);'},{'eval','listing'})
obj.addMatlabOutput({'R1'})
obj.setDefault('prettyComMax','prettyMaxSize')

obj.createTableOfContents;

obj.export
obj.generate
obj.view

obj.addMatlab({'close all'},{'eval'})



