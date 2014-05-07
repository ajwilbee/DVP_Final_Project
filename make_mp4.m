writerObj = VideoWriter('FieldWalkFinal.mp4','MPEG-4');
open(writerObj);
temp = movFinal;
for k = 1: length(temp)
    writeVideo(writerObj,temp(k).cdata);
end

close(writerObj);
writerObj = VideoWriter('FieldWalkFG.mp4','MPEG-4');
open(writerObj);
temp = mov;
for k = 1: length(temp)
    temp(k).cdata = imresize(temp(k).cdata,[256,256]);
    writeVideo(writerObj,temp(k).cdata);
end

close(writerObj);
writerObj = VideoWriter('FieldWalkBG.mp4','MPEG-4');
open(writerObj);
temp = mov2;
for k = 1: length(temp)
    temp(k).cdata = imresize(temp(k).cdata,[256,256]);
    writeVideo(writerObj,temp(k).cdata);
end

close(writerObj);