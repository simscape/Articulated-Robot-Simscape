function ptcldFinger = pointCloudFinger(wFinger,lFinger,ptcldDensity)
% Generate point cloud for gripper finger contact points.
% You can specify 
%           wFinger      : width of finger
%           lFinger      : length of finger
%           ptcldDensity : point cloud density

% Copyright 2023 - 2024 The MathWorks, Inc.

pd = round(ptcldDensity);

thetaFinger = 90;
a = wFinger-2*lFinger/tand(thetaFinger);
if rem(pd,2)>0
    distP = a/(pd-1);
else
    distP = a/(pd+1);
end
nHor = 2*round(lFinger/2/distP);
nVer = pd;
ii = 1;
jj = 1;
x = zeros(nHor,nVer);
y = zeros(nHor,nVer);
z = zeros(nHor,nVer);
len(ii) = 0.01;
for ii = 1:nHor
    len(ii) = wFinger-2*ii*lFinger/((nHor-1)*tand(thetaFinger));
    for jj = 1:nVer
        x(ii,jj) = (jj-0.5*(nVer+1))*len(ii)/(nVer-1);
        y(ii,jj) = (ii-1)*lFinger/(nHor-1)-lFinger/2;
        z(ii,jj) = 0;
    end
end
XX=reshape(x,[],1);
YY=reshape(y,[],1);
ZZ=reshape(z,[],1);
ptcldFinger = [XX YY ZZ];