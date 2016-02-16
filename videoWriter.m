clear all;
clc;
x=[-3:0.1:3];
y=[-3:0.1:3];
t=[0:0.1:5];
hFigure = figure;
numberOfFrames = length(t);
% Set up the movie structure.
% Preallocate recalledMovie, which will be an array of structures.
% First get a cell array with all the frames.
allTheFrames = cell(numberOfFrames,1);
vidHeight = 344;
vidWidth = 446;
allTheFrames(:) = {zeros(vidHeight, vidWidth, 3, 'uint8')};
% Next get a cell array with all the colormaps.
allTheColorMaps = cell(numberOfFrames,1);
allTheColorMaps(:) = {zeros(256, 3)};
% Now combine these to make the array of structures.
myMovie = struct('cdata', allTheFrames, 'colormap', allTheColorMaps);
% Create a VideoWriter object to write the video out to a new, different file.
% writerObj = VideoWriter('problem_3.avi');
% open(writerObj);
% Need to change from the default renderer to zbuffer to get it to work right.
% openGL doesn't work and Painters is way too slow.
set(gcf, 'renderer', 'zbuffer');
	
[x, y] = meshgrid(-3:.1:3,-3:.1:3);
for frameIndex = 1 : numberOfFrames
	z = exp(-(x-t(frameIndex)).^2-(y-t(frameIndex)).^2);
	cla reset;
	% Enlarge figure to full screen.
% 	set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
	surf(x,y,z);
	axis('tight')
	zlim([0, 1]);
	caption = sprintf('Frame #%d of %d, t = %.1f', frameIndex, numberOfFrames, t(frameIndex));
	title(caption, 'FontSize', 15);
	drawnow;
	thisFrame = getframe(gca);
	% Write this frame out to a new video file.
%  	writeVideo(writerObj, thisFrame);
	myMovie(frameIndex) = thisFrame;
end
% close(writerObj);
message = sprintf('Done creating movie\nDo you want to play it?');
button = questdlg(message, 'Continue?', 'Yes', 'No', 'Yes');
drawnow;	% Refresh screen to get rid of dialog box remnants.
close(hFigure);
if strcmpi(button, 'No')
   return;
end
hFigure = figure;
% Enlarge figure to full screen.
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
title('Playing the movie we created', 'FontSize', 15);
% Get rid of extra set of axes that it makes for some reason.
axis off;
% Play the movie.
movie(myMovie);
uiwait(helpdlg('Done with demo!'));
close(hFigure);