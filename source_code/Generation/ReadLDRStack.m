function stack = ReadLDRStack(dir_name, format)
%
%       stack = ReadLDRStack(dir_name, format)
%
%
%        Input:
%           -format: an LDR format for reading LDR images in the current directory 
%
%        Output:
%           -stack: a stack of LDR images
%
%     Copyright (C) 2011  Francesco Banterle
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

%Create a stack of images from the disk
list = dir([dir_name,'/*.',format]);
n = length(list);

stack = [];
for i=1:n
    disp(list(i).name);
    %read an image
    img = single(imread([dir_name,'/',list(i).name]));
    
    [r,c,col]=size(img);  
    if(i==1)
        stack = zeros(r,c,col,n);
    end
    
    %store in the stack
    stack(:,:,:,i) = img;    
end

end