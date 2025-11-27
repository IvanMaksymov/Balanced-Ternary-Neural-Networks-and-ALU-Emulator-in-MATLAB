function X = loadMNISTImages(filename)
fid = fopen(filename,'rb');
magic = fread(fid,1,'int32',0,'ieee-be');
if magic ~= 2051, error('Bad magic'); end
numImages = fread(fid,1,'int32',0,'ieee-be');
numRows   = fread(fid,1,'int32',0,'ieee-be');
numCols   = fread(fid,1,'int32',0,'ieee-be');
X = fread(fid,inf,'unsigned char');
fclose(fid);
X = reshape(X, numCols, numRows, numImages);
X = permute(X,[2 1 3]);
X = double(X)/255;
end

