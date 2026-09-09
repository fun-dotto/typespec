import "@typespec/http";
import "@typespec/openapi";
import "./model.tsp";

using Http;
using OpenAPI;

@service(#{ title: "Academic Service" })
@info(#{ version: "1.0.0" })
@server(
  "https://academic-api-107577467292.asia-northeast1.run.app",
  "Production"
)
@server("https://academic-api-qa-107577467292.asia-northeast1.run.app", "QA")
@server(
  "https://academic-api-stg-107577467292.asia-northeast1.run.app",
  "Staging"
)
@server(
  "https://academic-api-dev-107577467292.asia-northeast1.run.app",
  "Development"
)
@server("http://localhost:8080", "Local")
namespace AcademicService {
  @route("/v1/courseRegistrations")
  @tag("CourseRegistrations")
  interface CourseRegistrationsV1 {
    /**
     * 履修情報を取得する
     * @param userId ユーザーID
     * @param year 開講年度; 指定しない場合は今年度が選択される
     * @param semesters 開講時期; 指定された時期に開講される全ての科目が取得される
     * @returns 履修情報のリスト
     */
    @get list(
      @query userId: string,
      @query year?: integer,
      @query semesters: DottoFoundationV1.CourseSemester[],
    ): (OkResponse &
      Body<{
        courseRegistrations: CourseRegistration[];
      }>) | NotFoundResponse;

    /**
     * 履修情報を作成する
     * @param body 作成する履修情報の情報
     * @returns 作成された履修情報
     */
    @post create(@body body: CourseRegistrationRequest): (CreatedResponse &
      Body<{
        courseRegistration: CourseRegistration;
      }>) | BadRequestResponse;

    /**
     * 履修情報を削除する
     * @param id 履修情報ID
     * @returns 削除された履修情報
     */
    @delete delete(@path id: string): NoContentResponse | NotFoundResponse;
  }

  @route("/v1/faculties")
  @tag("Faculties")
  interface FacultiesV1 {
    /**
     * 教員一覧を取得する
     * @param q 検索ワード; 教員の名前で部分一致検索される
     * @returns 教員のリスト
     */
    @get list(@query q?: string): OkResponse &
      Body<{
        faculties: Faculty[];
      }>;

    /**
     * 教員を詳細取得する
     * @param id 教員ID
     * @returns 教員の詳細
     */
    @get detail(@path id: string): (OkResponse &
      Body<{
        faculty: Faculty;
      }>) | NotFoundResponse;

    /**
     * 教員を作成する
     * @param body 作成する教員の情報
     * @returns 作成された教員
     */
    @post create(@body body: FacultyRequest): CreatedResponse &
      Body<{
        faculty: Faculty;
      }>;

    /**
     * 教員を更新する
     * @param id 教員ID
     * @param body 更新する教員の情報
     * @returns 更新された教員
     */
    @put update(@path id: string, @body body: FacultyRequest): (OkResponse &
      Body<{
        faculty: Faculty;
      }>) | NotFoundResponse;

    /**
     * 教員を削除する
     * @param id 教員ID
     */
    @delete delete(
      @path id: string,
    ): NoContentResponse | NotFoundResponse | ConflictResponse;
  }

  @route("/v1/personalCalendarItems")
  @tag("PersonalCalendarItems")
  interface PersonalCalendarItemsV1 {
    /**
     * 個人カレンダーアイテム一覧を取得する
     *
     * @param userId ユーザーID
     * @param dates 日付のリスト; 指定した日付の個人カレンダーアイテムのみを取得する
     * @returns 個人カレンダーアイテムのリスト; 時間割、履修情報、休講補講、振替授業日情報から構築される
     */
    @get list(@query userId: string, @query dates: plainDate[]): OkResponse &
      Body<{
        personalCalendarItems: PersonalCalendarItem[];
      }>;
  }

  @route("/v1/cancelledClasses")
  @tag("CancelledClasses")
  interface CancelledClassesV1 {
    /**
     * 休講一覧を取得する
     * @param subjectIds 科目IDのリスト; 指定した科目の休講のみを取得する; 指定しない場合は全科目を検索対象とする
     * @param from 検索対象開始日付
     * @param until 検索対象終了日付
     * @returns 休講のリスト
     */
    @get list(
      @query subjectIds?: string[],
      @query(#{ explode: true }) from?: plainDate,
      @query(#{ explode: true }) until?: plainDate,
    ): OkResponse &
      Body<{
        cancelledClasses: CancelledClass[];
      }>;

    /**
     * 休講を作成する
     * @param body 作成する休講の情報
     * @returns 作成された休講
     */
    @post create(@body body: CancelledClassRequest): CreatedResponse &
      Body<{
        cancelledClass: CancelledClass;
      }>;

    /**
     * 休講を削除する
     * @param id 休講ID
     */
    @delete delete(@path id: string): NoContentResponse | NotFoundResponse;
  }

  @route("/v1/makeupClasses")
  @tag("MakeupClasses")
  interface MakeupClassesV1 {
    /**
     * 補講一覧を取得する
     * @param subjectIds 科目IDのリスト; 指定した科目の補講のみを取得する; 指定しない場合は全科目を検索対象とする
     * @param from 検索対象開始日付
     * @param until 検索対象終了日付
     * @returns 補講のリスト
     */
    @get list(
      @query subjectIds?: string[],
      @query(#{ explode: true }) from?: plainDate,
      @query(#{ explode: true }) until?: plainDate,
    ): OkResponse &
      Body<{
        makeupClasses: MakeupClass[];
      }>;

    /**
     * 補講を作成する
     * @param body 作成する補講の情報
     * @returns 作成された補講
     */
    @post create(@body body: MakeupClassRequest): CreatedResponse &
      Body<{
        makeupClass: MakeupClass;
      }>;

    /**
     * 補講を削除する
     * @param id 補講ID
     */
    @delete delete(@path id: string): NoContentResponse | NotFoundResponse;
  }

  @route("/v1/roomChanges")
  @tag("RoomChanges")
  interface RoomChangesV1 {
    /**
     * 教室変更一覧を取得する
     * @param subjectIds 科目IDのリスト; 指定した科目の教室変更のみを取得する; 指定しない場合は全科目を検索対象とする
     * @param from 検索対象開始日付
     * @param until 検索対象終了日付
     * @returns 教室変更のリスト
     */
    @get list(
      @query subjectIds?: string[],
      @query(#{ explode: true }) from?: plainDate,
      @query(#{ explode: true }) until?: plainDate,
    ): OkResponse &
      Body<{
        roomChanges: RoomChange[];
      }>;

    /**
     * 教室変更を作成する
     * @param body 作成する教室変更の情報
     * @returns 作成された教室変更
     */
    @post create(@body body: RoomChangeRequest): CreatedResponse &
      Body<{
        roomChange: RoomChange;
      }>;

    /**
     * 教室変更を削除する
     * @param id 教室変更ID
     */
    @delete delete(@path id: string): NoContentResponse | NotFoundResponse;
  }

  @route("/v1/rooms")
  @tag("Rooms")
  interface RoomsV1 {
    /**
     * 教室一覧を取得する
     * @param q 検索ワード; 部屋名・部屋番号・教員名の部分一致検索される
     * @param floors 階数; 指定した場合は指定した階数の部屋のみを取得する
     * @returns 教室のリスト
     */
    @get list(
      @query q?: string,
      @query floors?: DottoFoundationV1.Floor[],
    ): OkResponse &
      Body<{
        rooms: Room[];
      }>;

    /**
     * 教室を詳細取得する
     * @param id 教室ID
     * @returns 教室の詳細
     */
    @get detail(@path id: string): (OkResponse &
      Body<{
        room: Room;
      }>) | NotFoundResponse;

    /**
     * 教室を作成する
     * @param body 作成する教室の情報
     * @returns 作成された教室
     */
    @post create(@body body: RoomRequest): CreatedResponse &
      Body<{
        room: Room;
      }>;

    /**
     * 教室を更新する
     * @param id 教室ID
     * @param body 更新する教室の情報
     * @returns 更新された教室
     */
    @put update(@path id: string, @body body: RoomRequest): (OkResponse &
      Body<{
        room: Room;
      }>) | NotFoundResponse;

    /**
     * 教室を削除する
     * @param id 教室ID
     */
    @delete delete(
      @path id: string,
    ): NoContentResponse | NotFoundResponse | ConflictResponse;
  }

  @route("/v1/reservations")
  @tag("Reservations")
  interface ReservationsV1 {
    /**
     * 教室の予約一覧を取得する
     * 検索対象期間に一部でも重複する予約が取得される
     * @param roomIds 教室IDのリスト
     * @param from 検索対象開始日時
     * @param until 検索対象終了日時
     * @returns 予約のリスト
     */
    @get list(
      @query roomIds?: string[],
      @query(#{ explode: true }) from?: utcDateTime,
      @query(#{ explode: true }) until?: utcDateTime,
    ): OkResponse &
      Body<{
        reservations: Reservation[];
      }>;

    /**
     * 教室を予約する
     * @param body 予約する教室の情報
     * @returns 作成された予約
     */
    @post create(@body body: ReservationRequest): CreatedResponse &
      Body<{
        reservation: Reservation;
      }>;

    /**
     * 予約を削除する
     * @param id 予約ID
     */
    @delete delete(@path id: string): NoContentResponse | NotFoundResponse;
  }

  @route("/v1/subjects")
  @tag("Subjects")
  interface SubjectsV1 {
    /**
     * 科目一覧を取得する
     *
     * 同一項目同士はOR、異なる項目同士はANDでフィルタリングされます。
     *
     * @param ids 科目IDのリスト; 指定した場合は指定した科目IDのみを取得する
     * @param q 検索ワード
     * @param grades 学年
     * @param courses コース; 大学院の場合は大学院コースに読み替え
     * @param classes クラス; 大学院の学年を選択した場合は選択できない
     * @param classifications 学部: 専門・教養; 大学院: 専門・研究指導
     * @param year 開講年度; 指定しない場合は今年度が選択される
     * @param semesters 開講時期
     * @param requirementTypes 必修・選択・選択必修
     * @param culturalSubjectCategories 教養科目カテゴリ
     * @returns 科目のリスト
     */
    @get list(
      @query ids?: string[],
      @query q?: string,
      @query grades?: DottoFoundationV1.Grade[],
      @query courses?: DottoFoundationV1.Course[],
      @query classes?: DottoFoundationV1.Class[],
      @query classifications?: DottoFoundationV1.SubjectClassification[],
      @query year?: integer,
      @query semesters?: DottoFoundationV1.CourseSemester[],
      @query requirementTypes?: DottoFoundationV1.SubjectRequirementType[],

      @query
      culturalSubjectCategories?: DottoFoundationV1.CulturalSubjectCategory[],
    ): OkResponse &
      Body<{
        subjects: Subject[];
      }>;

    /**
     * 科目を詳細取得する
     * @param id 科目ID
     * @returns 科目の詳細
     */
    @get detail(@path id: string): (OkResponse &
      Body<{
        subject: Subject;
      }>) | NotFoundResponse;

    /**
     * 科目を削除する
     * @param id 科目ID
     */
    @delete delete(
      @path id: string,
    ): NoContentResponse | NotFoundResponse | ConflictResponse;
  }

  @route("/v1/subjects/{id}/syllabus")
  @tag("Syllabus")
  interface SyllabusV1 {
    /**
     * シラバスを取得する
     * @param id 科目ID
     * @returns シラバス
     */
    @get detail(@path id: string): (OkResponse &
      Body<{
        syllabus: Syllabus;
      }>) | NotFoundResponse;
  }

  @route("/v1/timetableItems")
  @tag("TimetableItems")
  interface TimetableItemsV1 {
    /**
     * 時間割を取得する
     *
     * @param year 開講年度; 指定しない場合は今年度が選択される
     * @param semesters 開講時期; 指定された時期に開講される全ての科目が取得される
     * @returns 時間割のリスト
     */
    @get list(
      @query year?: integer,
      @query semesters: DottoFoundationV1.CourseSemester[],
    ): OkResponse &
      Body<{
        timetableItems: TimetableItem[];
      }>;

    /**
     * 時間割に追加する
     * @param body 追加する時間割の情報
     * @returns 作成された時間割
     */
    @post create(@body body: TimetableItemRequest): CreatedResponse &
      Body<{
        timetableItem: TimetableItem;
      }>;

    /**
     * 時間割を削除する
     * @param id 時間割ID
     * @returns 削除された時間割
     */
    @delete delete(@path id: string): NoContentResponse | NotFoundResponse;
  }

  @route("/v1/facultyRooms")
  @tag("FacultyRooms")
  interface FacultyRoomsV1 {
    /**
     * 教員室を取得する
     *
     * @param year 年度; 指定しない場合は今年度が選択される
     * @returns 教員室のリスト
     */
    @get list(@query year?: integer): OkResponse &
      Body<{
        facultyRooms: FacultyRoom[];
      }>;

    /**
     * 教員室を追加する
     *
     * 同一年度で同じ教員または同じ教室が既に登録されている場合は409を返す。
     * @param body 追加する教員室の情報
     * @returns 作成された教員室
     */
    @post create(@body body: FacultyRoomRequest): (CreatedResponse &
      Body<{
        facultyRoom: FacultyRoom;
      }>) | ConflictResponse;

    /**
     * 教員室を削除する
     * @param id 教員室ID
     * @returns 削除された教員室
     */
    @delete delete(@path id: string): NoContentResponse | NotFoundResponse;
  }
}
