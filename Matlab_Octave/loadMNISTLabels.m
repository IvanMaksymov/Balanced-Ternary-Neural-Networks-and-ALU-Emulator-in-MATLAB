function labels = loadMNISTLabels(filename)
fid = fopen(filename,'rb');
magic = fread(fid,1,'int32',0,'ieee-be');
if magic ~= 2049, error('Bad magic'); end
numLabels = fread(fid,1,'int32',0,'ieee-be');
labels = fread(fid,inf,'unsigned char');
fclose(fid);
end

