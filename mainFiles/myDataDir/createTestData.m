n = 5;
filePre = 'data_';
fileExt = '.txt';
x = linspace(-pi,pi,300).';
for k = 1:n
    y_1 = sin(k*x);
    y_2 = cos(k*x);
    data = [x,y_1,y_2];
    fileName = [filePre,num2str(k),fileExt];
    save(fileName,'data','-ascii');
end