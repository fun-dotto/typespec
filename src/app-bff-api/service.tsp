import "@typespec/http";
import "@typespec/openapi";
import "./model.tsp";

using Http;
using OpenAPI;

@service(#{ title: "App BFF Service" })
@info(#{ version: "1.0.0" })
@server(
  "https://app-bff-api-107577467292.asia-northeast1.run.app",
  "Production"
)
@server("https://app-bff-api-qa-107577467292.asia-northeast1.run.app", "QA")
@server(
  "https://app-bff-api-stg-107577467292.asia-northeast1.run.app",
  "Staging"
)
@server(
  "https://app-bff-api-dev-107577467292.asia-northeast1.run.app",
  "Development"
)
@server("http://localhost:8080", "Local")
@useAuth(FoundationV1.FirebaseAppCheckAuth)
namespace AppBFFService {
  @route("/v1/announcements")
  @tag("Announcements")
  interface AnnouncementsV1 {
    /**
     * @returns おしらせのリスト
     */
    @get list(): (OkResponse &
      Body<{
        announcements: Announcement[];
      }>) | UnauthorizedResponse;
  }

  @useAuth([BearerAuth, FoundationV1.FirebaseAppCheckAuth])
  @route("/v1/courseRegistrations")
  @tag("CourseRegistrations")
  interface CourseRegistrationsV1 {
    /**
     * 履修情報を取得する
     * @param year 開講年度; 指定しない場合は今年度が選択される
     * @param semesters 開講時期
     * @returns 履修情報のリスト
     */
    @get list(
      @query year?: integer,
      @query semesters: DottoFoundationV1.CourseSemester[],
    ): (OkResponse &
      Body<{
        courseRegistrations: CourseRegistration[];
      }>) | UnauthorizedResponse;

    /**
     * 履修情報を作成する
     * @param body 作成する履修情報の情報
     * @returns 作成された履修情報
     */
    @post create(@body body: CourseRegistrationRequest): (CreatedResponse &
      Body<{
        courseRegistration: CourseRegistration;
      }>) | UnauthorizedResponse;

    /**
     * 履修情報を削除する
     * @param id 履修情報ID
     * @returns 削除された履修情報
     */
    @delete delete(
      @path id: string,
    ): NoContentResponse | NotFoundResponse | UnauthorizedResponse;
  }

  @useAuth([BearerAuth, FoundationV1.FirebaseAppCheckAuth])
  @route("/v1/personalCalendarItems")
  @tag("PersonalCalendarItems")
  interface PersonalCalendarItemsV1 {
    /**
     * 個人カレンダーアイテム一覧を取得する
     *
     * @param dates 日付のリスト; 指定した日付の個人カレンダーアイテムのみを取得する
     * @returns 個人カレンダーアイテムのリスト; 時間割、履修情報、休講補講、振替授業日情報から構築される
     */
    @get list(@query dates: plainDate[]): (OkResponse &
      Body<{
        personalCalendarItems: PersonalCalendarItem[];
      }>) | UnauthorizedResponse;
  }

  @useAuth([BearerAuth, FoundationV1.FirebaseAppCheckAuth])
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
    ): (OkResponse &
      Body<{
        cancelledClasses: CancelledClass[];
      }>) | UnauthorizedResponse;
  }

  @useAuth([BearerAuth, FoundationV1.FirebaseAppCheckAuth])
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
    ): (OkResponse &
      Body<{
        makeupClasses: MakeupClass[];
      }>) | UnauthorizedResponse;
  }

  @useAuth([BearerAuth, FoundationV1.FirebaseAppCheckAuth])
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
    ): (OkResponse &
      Body<{
        roomChanges: RoomChange[];
      }>) | UnauthorizedResponse;
  }

  @route("/v1/subjects")
  @tag("Subjects")
  interface SubjectsV1 {
    /**
     * 科目を検索する
     *
     * 同一項目同士はOR、異なる項目同士はANDでフィルタリングされます。
     *
     * @param q 検索ワード
     * @param grades 学年
     * @param courses コース; 大学院の場合は大学院コースに読み替え
     * @param classes クラス; 大学院の学年を選択した場合は選択できない
     * @param classifications 学部: 専門・教養; 大学院: 専門・研究指導
     * @param semesters 開講時期
     * @param requirementTypes 必修・選択・選択必修
     * @param culturalSubjectCategories 教養科目カテゴリ
     * @returns 科目のリスト
     */
    @get list(
      @query q?: string,
      @query grades?: DottoFoundationV1.Grade[],
      @query courses?: DottoFoundationV1.Course[],
      @query classes?: DottoFoundationV1.Class[],
      @query classifications?: DottoFoundationV1.SubjectClassification[],
      @query semesters?: DottoFoundationV1.CourseSemester[],
      @query requirementTypes?: DottoFoundationV1.SubjectRequirementType[],

      @query
      culturalSubjectCategories?: DottoFoundationV1.CulturalSubjectCategory[],
    ): (OkResponse &
      Body<{
        subjects: SubjectSummary[];
      }>) | UnauthorizedResponse;

    /**
     * @returns 科目の詳細
     */
    @get detail(@path id: string): (OkResponse &
      Body<{
        subject: SubjectDetail;
      }>) | NotFoundResponse | UnauthorizedResponse;
  }

  @route("/v1/timetableItems")
  @tag("TimetableItems")
  interface TimetableItemsV1 {
    /**
     * 時間割を取得する
     *
     * @param year 開講年度; 指定しない場合は今年度が選択される
     * @param semesters 開講時期
     * @returns 時間割のリスト
     */
    @get list(
      @query year?: integer,
      @query semesters: DottoFoundationV1.CourseSemester[],
    ): (OkResponse &
      Body<{
        timetableItems: TimetableItem[];
      }>) | UnauthorizedResponse;
  }

  @useAuth([BearerAuth, FoundationV1.FirebaseAppCheckAuth])
  @route("/v1/users")
  @tag("Users")
  interface UsersV1 {
    /**
     * ユーザーを取得する
     * @returns ユーザーの情報
     */
    @get detail(): (OkResponse &
      Body<{
        user: UserInfo;
      }>) | NotFoundResponse | UnauthorizedResponse;

    /**
     * ユーザーを作成または更新する
     * @param body 作成または更新するユーザーの情報
     * @returns 作成または更新されたユーザー
     */
    @post upsert(@body body: UserInfo): (OkResponse &
      Body<{
        user: UserInfo;
      }>) | UnauthorizedResponse;
  }

  @useAuth([BearerAuth, FoundationV1.FirebaseAppCheckAuth])
  @route("/v1/fcmTokens")
  @tag("FCM Tokens")
  interface FCMTokenV1 {
    /**
     * FCMトークンを作成または更新する
     * 存在しない場合は作成し、存在する場合は更新日時を更新する
     * @param body 作成または更新するFCMトークンの情報
     * @returns 作成または更新されたFCMトークン
     */
    @post upsert(@body body: FCMTokenRequest): (OkResponse &
      Body<{
        fcmToken: FCMToken;
      }>) | UnauthorizedResponse;
  }

  @route("/v1/menuItems")
  @tag("MenuItems")
  interface MenuItemsV1 {
    /**
     * メニューを取得する
     * @param date メニューを取得する日付
     * @returns メニューのリスト
     */
    @get list(@query date: plainDate): (OkResponse &
      Body<{
        menuItems: MenuItem[];
      }>) | UnauthorizedResponse;
  }

  @useAuth([BearerAuth, FoundationV1.FirebaseAppCheckAuth])
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
    ): (OkResponse &
      Body<{
        reservations: Reservation[];
      }>) | UnauthorizedResponse;
  }

  @route("/v1/busTrips")
  @tag("BusTrips")
  interface BusTripsV1 {
    /**
     * バスの運行情報を取得する
     *
     * @param date バスの運行情報を取得する日付
     *
     * @returns バスの運行情報のリスト
     */
    @get list(@query(#{ explode: true }) date: plainDate): (OkResponse &
      Body<{
        busTrips: BusTrip[];
      }>) | UnauthorizedResponse;
  }

  @route("/v1/busTrips/{tripId}/busTimetableStops")
  @tag("BusTimetableStops")
  interface BusTimetableStopsV1 {
    /**
     * バスの停車情報を取得する
     *
     * @param tripId 運行ID
     *
     * @returns バスの停車情報のリスト
     */
    @get list(@path tripId: string): (OkResponse &
      Body<{
        busTimetableStops: BusTimetableStop[];
      }>) | UnauthorizedResponse;
  }
}
