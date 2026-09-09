namespace AcademicService {
  model CourseRegistration {
    id: string;
    userId: string;
    subject: Subject;
  }

  model CourseRegistrationRequest {
    userId: string;
    subjectId: string;
  }

  model Faculty {
    id: string;
    name: string;
    email: string;
  }

  model FacultyRequest {
    name: string;
    email: string;
  }

  /**
   * 休講
   */
  model CancelledClass {
    id: string;
    subject: Subject;
    date: plainDate;
    period: DottoFoundationV1.Period;
    comment: string;
  }

  model CancelledClassRequest {
    subjectId: string;
    date: plainDate;
    period: DottoFoundationV1.Period;
    comment: string;
  }

  /**
   * 補講
   */
  model MakeupClass {
    id: string;
    subject: Subject;
    date: plainDate;
    period: DottoFoundationV1.Period;
    comment: string;
  }

  model MakeupClassRequest {
    subjectId: string;
    date: plainDate;
    period: DottoFoundationV1.Period;
    comment: string;
  }

  /**
   * 教室変更
   */
  model RoomChange {
    id: string;
    subject: Subject;
    date: plainDate;
    period: DottoFoundationV1.Period;
    originalRoom: Room;
    newRoom: Room;
  }

  model RoomChangeRequest {
    subjectId: string;
    date: plainDate;
    period: DottoFoundationV1.Period;
    originalRoomId: string;
    newRoomId: string;
  }

  model PersonalCalendarItem {
    date: plainDate;
    period: DottoFoundationV1.Period;
    subject: Subject;
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
     * 基準は現在の年度
     */
    faculty?: Faculty;
  }

  model RoomRequest {
    name: string;
    floor: DottoFoundationV1.Floor;
  }

  model Reservation {
    id: string;
    room: Room;
    startAt: utcDateTime;
    endAt: utcDateTime;
    title: string;
  }

  model ReservationRequest {
    roomId: string;
    startAt: utcDateTime;
    endAt: utcDateTime;
    title: string;
  }

  /**
   * 対象学年・クラス
   */
  model SubjectTargetClass {
    grade: DottoFoundationV1.Grade;

    /**
     * 修士課程・博士課程対象の場合はnull
     */
    class?: DottoFoundationV1.Class;
  }

  model Subject {
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
     *
     * 科目詳細取得でのみ必須
     */
    eligibleAttributes?: SubjectTargetClass[];

    /**
     * 科目群・科目区分をもとに決定
     *
     * 科目詳細取得でのみ必須
     */
    requirements?: SubjectRequirement[];
  }

  model SubjectFaculty {
    faculty: Faculty;
    isPrimary: boolean;
  }

  model SubjectFacultyRequest {
    facultyId: string;
    isPrimary: boolean;
  }

  model SubjectRequirement {
    course: DottoFoundationV1.Course;
    requirementType: DottoFoundationV1.SubjectRequirementType;
  }

  model SubjectRequirementRequest {
    course: DottoFoundationV1.Course;
    requirementType: DottoFoundationV1.SubjectRequirementType;
  }

  model Syllabus {
    /**
     * 教務システムのシラバスID
     */
    id: string;

    /**
     * 授業名
     */
    name: string;

    /**
     * 授業名 (en)
     */
    enName: string;

    /**
     * 配当年次
     */
    grades: string;

    /**
     * 単位数
     */
    credit: integer;

    /**
     * 担当教員名
     */
    facultyNames: string;

    /**
     * 実務家教員区分
     */
    practicalHomeFacultyCategory: string;

    /**
     * 複数人担当形式
     */
    multiplePersonTeachingForm: string;

    /**
     * 授業形態
     */
    teachingForm: string;

    /**
     * 授業の概要
     */
    summary: string;

    /**
     * 授業の到達目標
     */
    learningOutcomes: string;

    /**
     * 提出課題等
     */
    assignments: string;

    /**
     * 成績の評価方法・基準
     */
    evaluationMethod: string;

    /**
     * テキスト
     */
    textbooks: string;

    /**
     * 参考書
     */
    referenceBooks: string;

    /**
     * 履修条件
     */
    prerequisites: string;

    /**
     * 事前学習
     */
    preLearning: string;

    /**
     * 事後学習
     */
    postLearning: string;

    /**
     * 履修上の留意点
     */
    notes: string;

    /**
     * キーワード
     */
    keywords: string;

    /**
     * 対象コース・領域
     */
    targetCourses: string;

    /**
     * 対象領域
     */
    targetAreas: string;

    /**
     * 科目群・科目区分
     */
    classifications: string;

    /**
     * 教授言語
     */
    teachingLanguage: string;

    /**
     * 授業内容とスケジュール
     */
    contentsAndSchedule: string;

    /**
     * 授業・試験の形式
     */
    teachingAndExamForm: string;

    /**
     * DSOP対象科目
     */
    dsopSubject: string;
  }

  model TimetableItem {
    id: string;
    subject: Subject;

    /**
     * 集中講義など、時間割に含まれていない場合はnull
     */
    slot?: DottoFoundationV1.TimetableSlot;

    rooms: Room[];
  }

  model TimetableItemRequest {
    subjectId: string;
    slot?: DottoFoundationV1.TimetableSlot;
    roomIds: string[];
  }

  model FacultyRoom {
    id: string;
    faculty: Faculty;
    room: Room;
    year: integer;
  }

  model FacultyRoomRequest {
    facultyId: string;
    roomId: string;
    year: integer;
  }
}
