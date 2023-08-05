import os
import json

root = "D:\Smart_Recycler\data" # root 디렉토리
cnt = 0

# 디렉토리에서 특정 파일 삭제
def delete_files_by_name(file_name, search_path):
    global cnt
    cnt += 1

    for root, _, files in os.walk(search_path):
        for name in files:
            if name == file_name:
                file_path = os.path.join(root, name)
                try:
                    os.remove(file_path)
                    print(f"{cnt} - {file_path} 파일을 삭제했습니다.")
                except Exception as e:
                    print(f"{cnt} - {file_path} 파일을 삭제하는 중 오류가 발생했습니다: {str(e)}")

# Json 정보를 yolov5에 필요한 정보로 변경
def JsonToTxt(path, filename):
    global root

    file_root = path+'\\'+filename
    with open(file_root, 'r', encoding='UTF8') as f:
        json_data=json.load(f)

    try:
        # Json data yolov5 형식에 맞게 데이터 변경
        x1=int(json_data['Bounding'][0]['x1'])
        x2=int(json_data['Bounding'][0]['x2'])
        y1=int(json_data['Bounding'][0]['y1'])
        y2=int(json_data['Bounding'][0]['y2'])

        x_size=int(json_data['RESOLUTION'].split("*")[0])
        y_size=int(json_data['RESOLUTION'].split("*")[1])

        cl=json_data['Bounding'][0]['CLASS']
        x_center=((x1+x2)/2)/x_size
        y_center=((y1+y2)/2)/y_size
        width=(x2-x1)/x_size
        height=(y2-y1)/y_size

        # 각 클래스별로 yolov5 txt data 저장
        p = (root + "\\" + filename).replace("Json", "txt")
        fp = open(p, 'w')
        data = ''
        if cl=="유리병류": data=(str(2)+" "+str(x_center)+" "+str(y_center)+" "+str(width)+" "+str(height))
        elif cl=="종이류": data=(str(3)+" "+str(x_center)+" "+str(y_center)+" "+str(width)+" "+str(height))
        elif cl=="캔류": data=(str(4)+" "+str(x_center)+" "+str(y_center)+" "+str(width)+" "+str(height))
        else: data=(str(1)+" "+str(x_center)+" "+str(y_center)+" "+str(width)+" "+str(height))
        fp.write(data)
        fp.close()

    # x1에서 오류발생 (x1 좌표를 못 받아오는 경우) 시 해당 데이터 삭제
    except Exception:
        file_name_to_delete = filename.replace("Json", "jpg") # 삭제하고자 하는 파일 이름
        delete_files_by_name(file_name_to_delete, root)


for (path, dir, files) in os.walk(root+"\\labels"):
    for filename in files:
        ext = os.path.splitext(filename)[-1]
        if ext == '.Json':
            JsonToTxt(path, filename)