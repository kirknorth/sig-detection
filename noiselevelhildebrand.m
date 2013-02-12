function [P,stdP,nP,tshR2,maxSn] = noiselevelhildebrand(Sn,N,p)
%NOISELEVELHILDEBRAND Determine the noise level in power spectra based 
%on Hildebrand, P. H. and R. S. Sekhon, 1974: Objective determination of 
%the noise level in Doppler spectra.
%   [P,stdP,nP,tshR2,maxSn] = NOISELEVELHILDEBRAND(Sn,N,p) returns the 
%   mean noise level P for the spectrum Sn, the standard deviation of the 
%   spectral values used to calculate P, the number of points in the 
%   spectrum determined to be noise nP, the signal/noise critical threshold
%   tshR2, and the maximum value in the spectrum maxSn. 
%
%   The signal/noise threshold tshR2 is the critical value where the 
%   criterion for white noise has been met, while P is the mean of all the 
%   values in Sn below this critical value. 
%
%   Sn should be a vector and in linear units (e.g. mW), where P, tshR2, 
%   and maxSn will then be in linear units. Sn need not be a Doppler 
%   spectrum, but it must be a power spectrum. N is the number of 
%   independent spectral values, or simply LENGTH(Sn). p is the number of 
%   points over which a moving average of the spectrum was taken. If the 
%   spectrum has not been smoothed, then p = 1.
%
%   For more information, please see Hildebrand and Sekhon (1974).
%
%   Copyright (C) 2013 Kirk North
%   
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.

maxSn = nanmax(Sn); % maximum value in spectrum; linear units
Sn = sort(Sn,'descend'); % linear units
tshR2 = Sn(end); % set signal/noise threshold to lowest value in spectrum; linear units
for i = 1:N
    nP = N-i+1; % current number of points used to check white noise criteria
    P = nansum(Sn(i:end))/nP; % mean noise level for current search point; linear units
    Q = nansum(Sn(i:end).^2/nP)-P^2;
    R2 = P^2/(Q*p);
    stdP = nanstd(Sn(i:end)); % standard deviation for current search point; linear units
    if (R2 > 1) % white noise criteria has been met
        tshR2 = Sn(i); % signal/noise threshold; linear units
        break
    end
end