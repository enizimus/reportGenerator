clear 
clear classes
close all
clc

report = latexGenerator;
report.cleanDir;


report.addTitlePage;
report.addTableOfContents;
report.addHeading('chapter', 'First Chapter');
report.addHeading('section', 'First Section');
report.addHeading('subsection', 'First subsection');
report.addParagraph('asdasd');
report.addParagraph('TEXT');

report.addList('itemize', {'prvi','drugi','treci'});
report.addList('enumerate', {'prvi','drugi','treci'});

report.set('imagePerLine',1,'imageOption','width=0.80\textwidth')
f = gobjects(1,3);
f(1) = figure;
plot(randn(1,199));
f(2) = figure;
plot(randn(1,199));
f(3) = figure;
plot(randn(1,199));
report.addFigure(f, {'cap1', 'cap2', 'cap3'});

report.addList('enumerate', {'number van', 'number tu'});

num = randn(1,3);
%names = {'first','second','third'};

report.set('tableColLables', 'first,second,third');
report.set('tableRowLables','one,two,three');
%report.set('booktabs',1);
report.addTabular([num*3;num; num-2]);
report.setDefault('table');

report.set('dataFormat', '%i');
names = {'Enizio', 'Muhac', 'Hasse'};
age = [22;23;22];
height = [195; 187; 190];
T = table(age, height);

report.addTable(T,'friends');
report.setDefault('table');
% 
eqn = 'N(A) G(j\omega) = -1';
option = '';
report.addEquation(eqn);


report.export;
report.generate;
report.cleanUp;
report.view;