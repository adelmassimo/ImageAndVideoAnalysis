for i = 12:22  
    i
    if(i < 10)
        pathFolder=strcat('../img/g00',num2str(i),'/person*');
    else
        pathFolder=strcat('../img/g0',num2str(i),'/person*');
    end
    
    for person = dir(pathFolder)'
        path = strcat(person.folder,'/', person.name);
        s2centralFrameDetector
    end
end