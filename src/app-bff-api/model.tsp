import "../academic-api/model.tsp";

namespace AppBFFService {
  model Announcement {
    id: string;
    title: string;

    /**
     * 日時
     */
    date: utcDateTime;

    url: url;
  }

  model CourseRegistration {
    id: string;
    subject: SubjectSummary;
  }

  model CourseRegistrationRequest {
    subjectId: string;
  }

  model PersonalCalendarItem {
    date: plainDate;
    period: DottoFoundationV1.Period;
    subject: SubjectSummary;
    rooms: Room[];
    status: DottoFoundationV1.PersonalCalendarItemStatus;
  }

  model Room {
    id: string;

    /**
     * 部屋名
     */
    name: string;

    /**
     * フロア
     *
     * オンラインなどの仮想教室の場合はVirtualを使用
     */
    floor: DottoFoundationV1.Floor;

    /**
     * 教員
     *
     * 空室の教員室や教員室でない場合は省略
     */
    faculty?: Faculty;
  }

  model Reservation {
    id: string;
    room: Room;
    startAt: utcDateTime;
    endAt: utcDateTime;
    title: string;
  }

  model Faculty {
    id: string;
    name: string;
    email: string;
  }

  model SubjectDetail {
    id: string;
    name: string;
    faculties: SubjectFaculty[];

    /**
     * 開講年度
     */
    year: integer;

    /**
     * 開講時期
     */
    semester: DottoFoundationV1.CourseSemester;

    /**
     * 単位数
     */
    credit: integer;

    /**
     * 授業名末尾の`学年-クラス`をもとに決定
     */
    eligibleAttributes: AcademicService.SubjectTargetClass[];

    /**
     * 科目群・科目区分をもとに決定
     */
    requirements: AcademicService.SubjectRequirement[];

    syllabus: AcademicService.Syllabus;
  }

  model SubjectFaculty {
    faculty: AcademicService.Faculty;
    isPrimary: boolean;
  }

  model SubjectSummary {
    id: string;
    name: string;
    faculties: SubjectFaculty[];

    /**
     * 開講年度
     */
    year: integer;

    /**
     * 開講時期
     */
    semester: DottoFoundationV1.CourseSemester;

    /**
     * 単位数
     */
    credit: integer;

    /**
     * 科目群・科目区分をもとに決定
     */
    requirements: AcademicService.SubjectRequirement[];
  }

  /**
   * 休講
   */
  model CancelledClass {
    id: string;
    subject: SubjectSummary;
    date: plainDate;
    period: DottoFoundationV1.Period;
    comment: string;
  }

  /**
   * 補講
   */
  model MakeupClass {
    id: string;
    subject: SubjectSummary;
    date: plainDate;
    period: DottoFoundationV1.Period;
    comment: string;
  }

  /**
   * 教室変更
   */
  model RoomChange {
    id: string;
    subject: SubjectSummary;
    date: plainDate;
    period: DottoFoundationV1.Period;
    originalRoom: Room;
    newRoom: Room;
  }

  model TimetableItem {
    id: string;
    subject: SubjectSummary;

    /**
     * 集中講義など、時間割に含まれていない場合はnull
     */
    slot?: DottoFoundationV1.TimetableSlot;

    rooms: Room[];
  }

  model UserInfo {
    grade?: DottoFoundationV1.Grade;
    course?: DottoFoundationV1.Course;
    class?: DottoFoundationV1.Class;
  }

  model FCMToken {
    /**
     * FCMトークン
     */
    token: string;

    /**
     * 作成日時
     */
    createdAt: utcDateTime;

    /**
     * 更新日時
     */
    updatedAt: utcDateTime;
  }

  model FCMTokenRequest {
    token: string;
  }

  model MenuItem {
    id: string;
    date: plainDate;
    name: string;
    imageUrl: url;
    category: Category;
    prices: Price[];
  }

  model Price {
    size: Size;
    price: int32;
  }

  enum Size {
    Small,
    Medium,
    Large,
  }

  enum Category {
    SetAndSingle,
    BowlAndCurry,
    Noodle,
    Side,
    Dessert,
  }

  model BusStop {
    id: string;
    name: string;
  }

  model BusRoute {
    id: string;
    name: string;
  }

  model BusTimetableStop {
    tripId: string;
    stop: BusStop;
    departureTime: utcDateTime;
  }

  model BusTrip {
    id: string;
    departureTime: utcDateTime;
    arrivalTime: utcDateTime;
    route: BusRoute;

    /**
     * 乗車バス停、乗り換えバス停、降車バス停のリスト
     */
    stops: BusStop[];

    delay: duration;
    alert: BusAlert;
  }

  enum BusAlert {
    /**
     * 通常運行
     */
    None,

    /**
     * 運休
     */
    Cancellation,
  }
}
