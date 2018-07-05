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
f(1) = figure
plot(randn(1,199));
f(2) = figure
plot(randn(1,199));
f(3) = figure
plot(randn(1,199));
report.addFigure(f, {'cap1', 'cap2', 'cap3'});

report.addList('enumerate', {'number van', 'number tu'});

report.export;
report.generate;
report.cleanUp;
report.view;