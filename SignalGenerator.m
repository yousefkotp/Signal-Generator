clc
clear

prompt = {'Enter sampling frequecny: ','Enter start time: ','Enter end time: ','Enter number of break points: '};
dlgtitle = 'Signal Generator';
dims = [1 35];
answer = inputdlg(prompt,dlgtitle,dims);
answer = str2double(answer);
%Sampling Frequency, start time, end time, break points number
fs = answer(1);
startTime = answer(2);
endTime = answer(3);
breakPtsNums = answer(4);

breakPts = [];
for i = 1:breakPtsNums
    breakPts(i) = str2double(inputdlg(['Enter position for break point ' num2str(i) ' : ']));
end
    breakPts(breakPtsNums+1)= endTime;
%Signal Formation

regionStartTime = startTime;
tOP = [];
yOP = [];
for i = 1:breakPtsNums+1
    region = strcat(int2str(regionStartTime), ' : ', int2str(breakPts(i)));
    signalType = menu(strcat('Choose signal type for region ', region), 'DC Signal', 'Ramp Signal','General Order Polynomial Signal', 'Exponential Signal', 'Sinusoidal Signal');
    sample = (breakPts(i)-regionStartTime)*fs; % No. of samples
    t = linspace(regionStartTime, breakPts(i), sample);
    switch (signalType)
        case 1 %DC Signal
            amp = str2double(inputdlg('Enter amplitude of DC signal: '));
            y = amp*ones(1,sample);
        case 2 %Ramp Signal
            t2= t-regionStartTime;
            slope = str2double(inputdlg('Enter slope of Ramp signal: '));
            intercept = str2double(inputdlg('Enter intercept of Ramp signal: '));
            y = slope*t2 + intercept;
        case 3 %General Order Polynomial Signal
            ampPower = str2double(inputdlg('Enter the amplitude power:'));
            p = [] ;
            for j=0:ampPower
                power = str2double(inputdlg(strcat('Enter coefficient of X^', num2str(j))));
                p = [p power];
            end
            p = fliplr(p);
            y = polyval(p,t); % Poynomial evaluation
        case 4 %Exponential Signal
            amp = str2double(inputdlg('Enter amplitude of Exponential signal: '));
            exponent = str2double(inputdlg('Enter exponent of Exponential signal: '));
            y = amp*exp(exponent*t);
        case 5%"Sinusoidal Signal"
            amp = str2double(inputdlg('Enter amplitude of Sinosoidal signal: '));
            freq = str2double(inputdlg('Enter freq of Sinosoidal signal: '));
            phase = str2double(inputdlg('Enter phase of Sinosoidal signal: '));
            y = amp*sin(2*pi*freq*t + (0.0174532925 *phase));
        otherwise break;
    end
   regionStartTime = breakPts(i);
   tOP = [tOP t];
   yOP = [yOP y];
end
plot(tOP,yOP);
    tOperation = tOP;
    yOperation = yOP;
%Signal Operations
while(1)
    signalOperation = menu('Do you want to make an operation on the signal?', 'Amplitude Scaling', 'Time Reversal','Time Shift', 'Expanding the signal', 'Compressing the signal', 'None');

    switch (signalOperation)
        case 1 %"Amplitude Scaling"
            scale = str2double(inputdlg('Enter scale value: '));
            yOperation = scale*yOperation;
        case 2 %"Time Reversal"
            tOperation = fliplr(-tOperation);
            yOperation = fliplr(yOperation);
        case 3 %"Time Shift"
            shift = str2double(inputdlg('Enter shift value: '));
            tOperation = tOperation  + shift;
        case 4 %"Expanding the signal"
            c = str2double(inputdlg('Enter expanding value: '));
            if c ~= 0
                tOperation = c*tOperation;
            end
        case 5 %"Compressing the signal"
            c = str2double(inputdlg('Enter compressing value: '));
            if c ~= 0
                tOperation = (1/c)*tOperation;
            end
        otherwise break;
    end
    plot(tOperation, yOperation)
end
