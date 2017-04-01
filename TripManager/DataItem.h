//
//  DataItem.h
//  TripManager
//
//  Created by 何家瑋 on 2017/2/21.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataItem : NSObject

#pragma mark - table column
// for base data table
@property (nonatomic) NSString * Add;
@property (nonatomic) NSString * Class;
@property (nonatomic) NSString * Class1;
@property (nonatomic) NSString * Class2;
@property (nonatomic) NSString * Class3;
@property (nonatomic) NSString * Description;
@property (nonatomic) NSString * Gov;
@property (nonatomic) NSString * Id;
@property (nonatomic) NSString * Keyword;
@property (nonatomic) NSString * Level;
@property (nonatomic) NSString * Map;
@property (nonatomic) NSString * Name;
@property (nonatomic) NSString * Opentime;
@property (nonatomic) NSString * Orgclass;
@property (nonatomic) NSString * Parkinginfo;
@property (nonatomic) NSString * Parkinginfo_Px;
@property (nonatomic) NSString * Parkinginfo_Py;
@property (nonatomic) NSString * Picdescribe1;
@property (nonatomic) NSString * Picdescribe2;
@property (nonatomic) NSString * Picdescribe3;
@property (nonatomic) NSString * Picture1;
@property (nonatomic) NSString * Picture2;
@property (nonatomic) NSString * Picture3;
@property (nonatomic) NSString * Px;
@property (nonatomic) NSString * Py;
@property (nonatomic) NSString * Remarks;
@property (nonatomic) NSString * Tel;
@property (nonatomic) NSString * Ticketinfo;
@property (nonatomic) NSString * Serviceinfo;
@property (nonatomic) NSString * Toldescribe;
@property (nonatomic) NSString * Travellinginfo;
@property (nonatomic) NSString * Website;
@property (nonatomic) NSString * Zipcode;
@property (nonatomic) NSString * Zone;

// for schedule table
@property (nonatomic) NSString * Date;
@property (nonatomic) NSString * OrderIndex;
@property (nonatomic) NSString * DataItemType;

#pragma mark - customized
// for customized
@property (nonatomic) NSString * CustomRemarks; // for user note what they what to remerber
@property (nonatomic) NSString * VisitTime;



/*  sample
 //scenicspot
 Add: "基隆市仁愛區仁三路27之2號",
 Class1: "04",
 Class2: "12",
 Class3: "00",
 Description: "佇立在夜市裡的奠濟宮，已有百餘年的歷史，是基隆市民生活的一部份，四周小吃林立，是基隆市最熱鬧的地方之一。殿內的雕樑畫棟、古色古香，在這樣熱鬧非凡的街道中，讓人想不到存在著一間這麼古樸且香火鼎盛的廟宇。",
 Gov: "376570000A",
 Id: "C1_376570000A_000073",
 Keyword: "奠濟宮",
 Level: "9",
 Map: "http://g.co/maps/zy9ab",
 Name: "奠濟宮",
 Opentime: "07:00~22:00",
 Orgclass: "廟宇祈福",
 Parkinginfo: "東岸立體停車場信二路公有停車場博愛國宅地下室停車場",
 Parkinginfo_Px: "121.743800",
 Parkinginfo_Py: "25.130330",
 Picdescribe1: "奠濟宮1",
 Picdescribe2: "奠濟宮2",
 Picdescribe3: "奠濟宮3",
 Picture1: "http://tour.klcg.gov.tw/KeelungNGIS/ScenicSpots/奠濟宮1.jpg",
 Picture2: "http://tour.klcg.gov.tw/KeelungNGIS/ScenicSpots/奠濟宮2.jpg",
 Picture3: "http://tour.klcg.gov.tw/KeelungNGIS/ScenicSpots/奠濟宮3.jpg",
 Px: "121.743200",
 Py: "25.128380",
 Remarks: "",
 Tel: "886-2-24289266",
 Ticketinfo: "免門票",
 Toldescribe: "基隆廟口夜市的「廟」指的就是隱身在夜市中的奠濟宮，建於清同治十二年(西元1873年)，已有130多年的歷史，是一座百年古剎，為基隆市區最大型的廟宇，廟內供奉的是開漳聖王，也就是唐朝的陳元光將軍，其誕辰迄今已有是1300多年。開漳聖王是河南人，在唐垂拱二年(西元686年)奉命平定閩粵，由於開拓邊疆，安撫當地民眾，恩澤及於閩臺，死後封為開漳聖王。 基隆的先民大多來自閩南，因而對開漳聖王陳元光將軍的德威，非常仰慕；而在基隆建廟奉祀。當時由基隆地方士紳等購買外木山十多頃田地為廟產，以木料建廟其上，但是後來由板橋望族林本源等捐獻現在仁愛區王田里現址 ，並獲得地方熱烈響應，於清光緒元年(西元1875年)建成，當時的奠濟宮、精工細琢，非常壯觀。二次世界大戰奠濟宮也遭炸燬，再加風雨侵蝕多年，宮廟殘破不堪，民國53年由地方人士捐款修建並興建前殿及兩廊鐘鼓樓，使基隆奠濟宮有今日之規模。一般由入廟的階梯數多寡來分辨廟宇的大小以及參禮神祈地位的高低，奠濟宮主祭為開漳聖王陳元光將軍，並奉祀各方神明，開漳聖王在一般民間信仰的道教神明排行上並不是很高，但是在漳州移民心中的地位卻是至高無上的，傳說中的聖王，是唐代的武進士，其不僅平定閩粵邊境之亂，並曾上奏請建漳州，死後地方百姓為崇功報德，在各地建廟隆祀，因此基隆以"七階" 大廟來供奉聖王，所以也稱奠濟宮為「聖王宮廟」。 走入廟殿內，殿內的雕樑畫棟、古色古香，更令人難以置信的是，在這樣熱鬧非凡的街道中，竟存在著一間這麼古樸且香火鼎盛的廟宇，經年累月總是有著一批又一批的信眾前往膜拜，每年農曆2月15日奠濟宮暨協辦單位得意堂第十組一大早就會舉行祭典，下午則有遊境拜廟的活動，當天奠濟宮管理委員會還會聘請歌仔戲公演兩天，祈求風調雨順，若有人加棚謝戲，還會熱鬧個三、四天左右。",
 Travellinginfo: "基隆火車站前站出發，直走忠一路，右轉愛四路即可抵達，步行時間約10分鐘。於「二信循環站」下車，步行即可抵達(適合回程)。",
 Website: "",
 Zipcode: "200",
 Zone: ""
 
 
 //hotel
 Add: "屏東縣恆春鎮墾丁路6號",
 Class: "1",
 Description: "台灣首家榮獲觀光局「五星級認證」之休閒飯店的墾丁凱撒大飯店，位於國境之南，擁有最適合旅遊的獨特條件，以極致服務、高隱私及完美SPA三項目，連續9年「2007-2015」獲選與峇里島寶格利酒店同級的EIHR「世界頂級島嶼飯店聯盟」會員，成為國內外推崇台灣最頂級的渡假選擇！ 全館281間的客房提供您舒適的休憩空間，另有六大主題餐廳及酒吧，以及420坪的休閒中心、充滿南國風情的椰林泳池、活力四射的小灣沙灘，完整而豐富的設施滿足房客所有的渡假需求！",
 Fax: "886-8-8861818",
 Gov: "315080000H",
 Grade: "5",
 Id: "C4_315080000H_100001",
 Map: "",
 Name: "凱撒大飯店",
 Parkinginfo: "車位:小客車127輛、機車10輛、大客車3輛",
 Picdescribe1: "游泳池",
 Picdescribe2: "Angsana Spa館",
 Picdescribe3: "庭園",
 Picture1: "http://taiwanstay.net.tw/public/data/201209251136201603917.jpg",
 Picture2: "http://taiwanstay.net.tw/public/data/201209251136201603045.jpg",
 Picture3: "http://taiwanstay.net.tw/public/data/201209251136201638058.jpg",
 Px: "120.805222",
 Py: "21.941916",
 Serviceinfo: "餐廳,會議場所,咖啡廳,酒吧,宴會廳,健身房,商店,游泳池,有線網路,無線上網,國民旅遊卡,停車場,兒童遊樂設施,洗衣服務,郵電服務,商務旅遊中心,各式球場,室內遊樂設施,接送服務,自行車租借,外幣兌換,導覽解說,體驗活動",
 Spec: "",
 Tel: "886-8-8861888",
 Website: "http://www.caesarpark.com.tw",
 Zipcode: "946"
 
 
 //restaurant
 Add: "赤崁村9-1號",
 Class: "03",
 Description: "以海鮮合菜為主，由於靠赤崁碼頭，漁獲相當的多，所以在價格上非常的便宜，不過夏天時由於團體客人頗多，散客如果要在此吃飯建議要事先預約。",
 Id: "C3_315080600H_000057",
 Map: "",
 Name: "韓湘館【白沙鄉】",
 Opentime: "全天",
 Parkinginfo: "",
 Picdescribe1: "韓湘館",
 Picdescribe2: "",
 Picdescribe3: "",
 Picture1: "http://www.penghu-nsa.gov.tw/FileDownload/Scenery/Big/20140911152951787.JPG",
 Picture2: "",
 Picture3: "",
 Px: "119.600100",
 Py: "23.665110",
 Tel: "886-6-9932259",
 Website: "",
 Zipcode: "884"
 */
@end
