function imgOut = DragoTMO(img, d_Ld_Max, d_b)
%
%
%        imgOut = DragoTMO(img, d_Ld_Max, d_b)
%
%
%        Input:
%           -img: input HDR image
%           -d_Ld_Max: maximum output luminance of the LDR display
%           -d_b: bias parameter to be in (0,1]. The default value is 0.85 
%
%        Output:
%           -imgOut: tone mapped image
% 
%     Copyright (C) 2010-13 Francesco Banterle
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%     The paper describing this technique is:
%     "Adaptive Logarithmic Mapping for Displaying High Contrast Scenes"
% 	  by Frederic Drago, Karol Myszkowski, Thomas Annen, Norishige Chiba
%     in Proceedings of Eurographics 2003
%

%Is it a luminance or a three color channels image?
check13Color(img);

checkNegative(img);

if(~exist('d_Ld_Max', 'var'))
    d_Ld_Max = 100; %cd/m^2
end

if(~exist('d_b', 'var'))   
    d_b = 0.85;
end

%Luminance channel
L = lum(img);

Lwa = logMean(L);
Lwa = Lwa / ((1.0 + d_b - 0.85)^5);
LMax = max(L(:));

L_wa = L / Lwa;
LMax_wa = LMax / Lwa;

c1 = log(d_b) / log(0.5);
p1 = (d_Ld_Max / 100.0) / (log10(1 + LMax_wa));
p2 = log(1.0 + L_wa) ./ log(2.0 + 8.0 * ((L_wa / LMax_wa).^c1));
Ld = p1 * p2;

%Changing luminance
imgOut = ChangeLuminance(img, L, Ld);

disp('Note that tone mapped images with DragoTMO should be gamma corrected with function GammaDrago.m');

end
