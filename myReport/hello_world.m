close all
clear classes
clc

report = latexGenerator;
report.set('settingFile', 'hellow_settings.dat');
report.addParagraph('hello world');
report.export;
report.generate;
report.cleanUp;