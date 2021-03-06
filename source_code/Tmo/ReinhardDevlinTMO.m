function imgOut = ReinhardDevlinTMO(img, rd_f, rd_m, rd_a, rd_c)
%
%
%      imgOut = ReinhardDevlinTMO(img, pAlpha, pWhite, pLocal, phi)
%
%
%       Input:
%           -img: input HDR image
%	    -rd_f: overall intensity in [0.3, 1.0]
%	    -rd_m: contrast in [-8.0, 8.0]
%	    -rd_a: adaptation in [0.0, 1.0]
%	    -rd_c: color correction [0.0, 1.0]
%
%       Output:
%           -imgOut: output tone mapped image in linear domain
%
%     Copyright (C) 2013  Francesco Banterle
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

%is it a three color channels image?
check3Color(img);

%Luminance channel
L = lum(img);
Lav = logMean(L);

if(~exist('rd_m'))
    Lmax = max(L(:));
    Lmin = min(L(:));
    k = (log(Lmax) - log(Lav))/(log(Lmax)-log(Lmin));
    rd_m = 0.3 + 0.7*k^1.4;
else
    rd_m = ClampImg(rd_m, 0.3, 1.0);
end

if(~exist('rd_f'))
    rd_f = 0.0;
else
    rd_f = ClampImg(rd_f, -8.0, 8.0);
end

if(~exist('rd_c'))
   rd_c = 0.0; 
else
    rd_c = ClampImg(rd_c, 0.0, 1.0);
end

if(~exist('rd_a'))
    rd_a = 1.0;
else
    rd_a = ClampImg(rd_a, 0.0, 1.0);
end

imgOut = zeros(size(img));

rd_f = exp(-rd_f);

for i=1:3
    Cav = mean(mean(img(:,:,i)));

    I_l = rd_c*img(:,:,i) + (1-rd_c)*L;
    I_g = rd_c*Cav        + (1-rd_c)*Lav;
    I_a = rd_a*I_l        + (1-rd_a)*I_g;

    imgOut(:,:,i) = img(:,:,i)./(img(:,:,i)+(rd_f*I_a)^rd_m);
end

imgOut = RemoveSpecials(imgOut);

end