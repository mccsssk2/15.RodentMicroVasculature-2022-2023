%
% This happens after I have cleaned up the connectivity manually, added start and end points, and trim points.
%
% SRK. 16 August 2022.
% SRK 2 Sept. 2022. This SWC maker needs to be aligned with the Melvin Tiang version of swc2vtk.py.
% Issues: 1) parents are 0s. 2) I have an arbirtrary p1 at node 1. 3) The data format (float or int) is different from what the python expects.
clear all
clear all
close all
close all
%
%
% read connectivity. It also has the start (which were in blobs.xlsx) and end trim points.
% first column is a serial number that python puts in as row number. Dont use it.
conn 	= load('connectivity.dat');
% read the vessels sequence that I got from the zip file.
fid 		= fopen('vesselsInSequence.dat');
fnames 	= textscan( fid, '%s', 'Delimiter', '\n' );
Nsample = 1;
%
% error message.
if(length(conn)~=length(fnames{1}))
	fprintf("number of ROIs and connectivity length do not agree. Exit.\n");
	return;
end;

for i =1:1:length(fnames{1}) % vessel number.
%	i
	if(i~=conn(i,2))
		fprintf("iterator and vessel number do not agree. Exit.\n");
		return;
	end;
%
	str 			= strcat('ROIs/', fnames{1}{i});
	sROI 		= ReadImageJROI(str);
	coodsRaw 	= sROI.mnCoordinates;
	% do trim first, then add the start and end coods.
	istart 		= conn(i,10);
	iend 		= conn(i,11);
	coods1 		= coodsRaw(istart:(end-iend), :);
	% add start and end coods.
	if(conn(i,6)>=0&&conn(i,7)>=0&&conn(i,8)>=0&&conn(i,9)>=0)
		 startx = conn(i,6); starty = conn(i,7);
		 endx = conn(i,8);  endy = conn(i,9);
		 coods1 = [startx starty; coods1; endx endy];	
	elseif(conn(i,6)>=0&&conn(i,7)>=0&&conn(i,8)<0&&conn(i,9)<0)
		 startx = conn(i,6); starty = conn(i,7);
		 coods1 = [startx starty; coods1];		
	elseif(conn(i,6)<0&&conn(i,7)<0&&conn(i,8)>=0&&conn(i,9)>=0)
		 endx = conn(i,8);  endy = conn(i,9);
		 coods1 = [coods1; endx endy];	
	end
	
	% in case there are repeated coordinates.
	coods = unique(coods1,'rows','stable'); % stable means do not sort.

% reverse the coods if there is a file called vesselsReversed.data .
	if(exist('vesselsReversed.data','file'))
		revFiles = load('vesselsReversed.data');
		if(ismember(i,revFiles))
			coods = flip(coods);
%			return	
		end
	end
	
	% now put it all into the SWC struct.
	meLen = 0.0;
	if(i==1)
		jswc = 1; % this comes down from previous vessel.
	end;
	
	for j=1:1:length(coods(:,1))
		swc(jswc).meNode = jswc;
		swc(jswc).p1Node = -2; swc(jswc).p2Node = -2; % impossible values. root is when p1 and p2 are both -1.
		if(j>1)
			swc(jswc).p1Node = swc(jswc-1).meNode;
			swc(jswc).p2Node = -1;
		end;

		swc(jswc).x 		= coods(j,1); swc(jswc).y = coods(j,2); swc(jswc).z = 0;
		swc(jswc).strahler 	= conn(i,5); 
		swc(jswc).meVess = conn(i,2); swc(jswc).p1Vess = conn(i,3); swc(jswc).p2Vess = conn(i,4);
		if(j>1)
			meLen = meLen + sqrt( (swc(jswc).x - swc(jswc-1).x).^2 + (swc(jswc).y - swc(jswc-1).y).^2 );
		end;
		jswc = jswc + 1;
	end
	
	lengths(i) = meLen;
	clearvars -except swc jswc lengths conn fnames Nsample i
end; % end of i loop.

% at this stage, all starts of vessels have -2 -2 in parent1 and parent2.
% deal with parents at start of vessel nodes.
for i =1:1:length(fnames{1}) % vessel number.
	meVess = conn(i,2); % in this loop, your problem is the first node of that vessel.
	
	for j=1:1:length(swc)
		if(swc(j).meVess==meVess)
			meNode = swc(j).meNode;
			p1Vess = swc(j).p1Vess;
			p2Vess = swc(j).p2Vess;
			break;
		end;
	end

	p1Node = -1; p2Node = -1;
	for j=1:1:length(swc)
		if(p1Vess>0&&p1Vess==swc(j).meVess)
			p1Node = swc(j).meNode;
		end;
		if(p2Vess>0&&p2Vess==swc(j).meVess)
			p2Node = swc(j).meNode;
		end;
	end	
	
	swc(meNode).p1Node = p1Node; swc(meNode).p2Node = p2Node;
%	fprintf("%d %d %d %d %d %d %d\n", i, meVess, meNode, p1Vess, p1Node, p2Vess, p2Node);
% return
end; % end of vessel number loop.

if(1==2) plot([swc.x], [swc.y], '.','markersize',12,'color',[0 0 0]); end;

% write it all to files.
% lengths.
writematrix(lengths', 'Lengths.dat');
% write the SWC.
fid = fopen('microVasc.swc','w');
for i=1:1:length(swc)
fprintf(fid, "%d %d %d %d %d %d %d %d\n",swc(i).meNode, swc(i).strahler, swc(i).x, swc(i).y, swc(i).z, swc(i).strahler, swc(i).p1Node, swc(i).p2Node);
end
