/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { router } from '@kit.ArkUI';
import HealthText from './HealthTextComponent';
import AddBtn from '../view/home/AddBtnComponent';
import { TaskCard } from '../view/home//TaskCardComponent';
// import HomeTopView from '../view/home/HomeTopComponent';
import DeviceTopView from '../view/device/DeviceTopComponent';

// modify by wyz
// import { TargetSettingDialog, RemindTimeDialog, FrequencyDialog } from '../view/dialog/TaskSettingDialog';
import { formatParams } from '../viewmodel/TaskViewModel';

import { DeviceCustomDialogView, CustomDialogCallback } from '../view/dialog/DeviceCustomDialogView';
import TaskInfo from '../viewmodel/TaskInfo';
// import { HomeStore } from '../viewmodel/HomeViewModel';
import { DeviceStore } from '../viewmodel/DeviceViewModel';
import { ITaskItem, TaskMapById } from '../model/TaskInitList';
import { HealthDataSrcMgr } from '../common/utils/HealthDataSrcMgr';
import { BroadCast, BroadCastType } from '../common/utils/BroadCast';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import AchievementInfo from '../viewmodel/AchievementInfo';

const WHITE_COLOR_0X = 255;

@Styles
function allSize() {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

@Extend(Text)
function titleTextStyle() {
  .fontSize($r('app.float.default_16'))
  .fontWeight(Const.FONT_WEIGHT_500)
  .width(Const.THOUSANDTH_1000)
  .fontFamily($r('app.string.HarmonyHeiTi_Medium'))
  .fontColor($r(`app.element.color.titleColor`))
  .padding({
    top: Const.THOUSANDTH_15,
    bottom: Const.THOUSANDTH_15,
    left: Const.THOUSANDTH_33
  })
}

@Component
export default struct DeviceIndex {
  @Provide broadCast: BroadCast = HealthDataSrcMgr.getInstance().getBroadCast();
  @State naviAlpha: number = 0;
  @Link deviceStore: DeviceStore;
  @Link editedTaskInfo: ITaskItem;
  @Link @Watch('taskChange') editedTaskID: string;
  private scroller: Scroller = new Scroller();
  private yOffset: number = 0;
  private device_infoArr: string[] = ["消息提醒", "来电提醒", "开启后台运行权限"];
  private health_infoArr: string[] = ["心率设置", "睡眠设置", "压力设置", "久坐提醒", "达标提醒"];
  private safe_infoArr: string[] = ["设备密码", "解锁手机", "解锁笔记本", "限制绑定"];

  taskChange() {
    this.deviceStore.updateTaskInfoList(this.editedTaskInfo);
  }

  taskItemAction(item: TaskInfo, isClick: boolean): void {
    if (!this.deviceStore.checkCurrentDay()) {
      return;
    }
    if (isClick) {
      // click to clock
      let callback: CustomDialogCallback = {
        confirmCallback: (taskTemp: TaskInfo) => {
          this.onConfirm(taskTemp)
        }, cancelCallback: () => {
        }
      };
      this.broadCast.emit(BroadCastType.SHOW_TASK_DETAIL_DIALOG, [item, callback]);
    } else {
      // edit task
      let editTaskStr: string = JSON.stringify(TaskMapById[item.taskID - 1]);
      let editTask: ITaskItem = JSON.parse(editTaskStr);
      editTask.targetValue = item?.targetValue;
      editTask.isAlarm = item.isAlarm;
      editTask.startTime = item.startTime;
      editTask.frequency = item.frequency;
      editTask.isOpen = item.isOpen;
      router.pushUrl({ url: 'pages/TaskEditPage', params: { params: JSON.stringify(editTask) } });
    }
  }

  //confirm clockL
  onConfirm(task: TaskInfo) {
    this.deviceStore.taskClock(task).then((res: AchievementInfo) => {
      if (res.showAchievement) {
        let achievementLevel = res.achievementLevel;
        if (achievementLevel) {
          this.broadCast.emit(BroadCastType.SHOW_ACHIEVEMENT_DIALOG, achievementLevel);
        } else {
          this.broadCast.emit(BroadCastType.SHOW_ACHIEVEMENT_DIALOG);
        }
      }
    })
  }

  // change navigator alpha when scrolling the Scroll component
  onScrollAction() {
    this.yOffset = this.scroller.currentOffset().yOffset;
    if (this.yOffset > Const.DEFAULT_56) {
      this.naviAlpha = 1;
    } else {
      this.naviAlpha = this.yOffset / Const.DEFAULT_56;
    }
  }

  editTaskAction() {
    if (this.deviceStore.checkCurrentDay()) {
      router.pushUrl({ url: 'pages/TaskListPage' });
    }
  }

  build() {
    Stack() {
      Scroll(this.scroller) {
        Column() {

          DeviceTopView({ deviceStore: $deviceStore })
          Text($r('app.string.device_list')).titleTextStyle()

          Row() {
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.ic_device')).width(30).height(30)
            }.width(30).height(30).margin({ 'left': -20 }).backgroundColor(0xFFFFFF)
            Text("查看所有设备")
              .onClick((  ) => {
                router.pushUrl({
                  url: "pages/DeviceListPage"
                })
              })
          }

          // FrequencyDialog()
          if (this.deviceStore.getTaskListOfDay().length > 0) {
            Column({ space: Const.DEFAULT_8 }) {
              ForEach(this.deviceStore.getTaskListOfDay(), (item: TaskInfo) => {
                TaskCard({
                  taskInfoStr: JSON.stringify(item),
                  clickAction: (isClick: boolean) => this.taskItemAction(item, isClick)
                })
                  .margin({ bottom: Const.DEFAULT_12 })
                  .height($r('app.float.default_64'))
              }, (item: TaskInfo) => JSON.stringify(item))
            }
            .onAppear(() => {
              this.scroller.scrollTo({ xOffset: 0, yOffset: this.yOffset });
            })
            .padding({
              top: Const.THOUSANDTH_15,
              left: Const.THOUSANDTH_33,
              right: Const.THOUSANDTH_33
            })
            .width(Const.THOUSANDTH_1000)
          } else {
            Column({ space: Const.DEFAULT_8 }) {
              Image($r('app.media.ic_no_data'))
                .width($r('app.float.default_132'))
                .height($r('app.float.default_100'));
              HealthText({ title: '', titleResource: $r('app.string.no_device'), fontSize: $r('app.float.default_14') })
                .opacity(Const.OPACITY_4)
            }
            .margin({ top: Const.DEFAULT_48 })
          }

          Text('通知设置').titleTextStyle()
          // 通知列表 start
          List({ space: 10, initialIndex: 0 }) {
            ForEach(this.device_infoArr, (item: string) => {
              ListItem() {
                Text('' + item)
                  .width('100%').height(50).fontSize(16)
                  .textAlign(TextAlign.Center).borderRadius(10).backgroundColor(0xFFFFFF)
              }
            }, (item: string) => item)
          }
          .listDirection(Axis.Vertical) // 排列方向
          .scrollBar(BarState.Off)
          .friction(0.6)
          .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
          .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
          .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
            console.info('first' + firstIndex)
            console.info('last' + lastIndex)
            console.info('center' + centerIndex)
          })
          .onScrollVisibleContentChange((start: VisibleListContentInfo, end: VisibleListContentInfo) => {
            console.log(' start index: ' + start.index +
              ' start item group area: ' + start.itemGroupArea +
              ' start index in group: ' + start.itemIndexInGroup)
            console.log(' end index: ' + end.index +
              ' end item group area: ' + end.itemGroupArea +
              ' end index in group: ' + end.itemIndexInGroup)
          })
          .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
            console.info(`onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` + scrollOffset)
          })
          .width('90%')
          // 通知列表 end

          Text('运动健康设置').titleTextStyle()
          // 运动健康设置列表 start
          List({ space: 10, initialIndex: 0 }) {
            ForEach(this.health_infoArr, (item: string) => {
              ListItem() {
                Text('' + item)
                  .width('100%').height(50).fontSize(16)
                  .textAlign(TextAlign.Center).borderRadius(10).backgroundColor(0xFFFFFF)
              }
            }, (item: string) => item)
          }
          .listDirection(Axis.Vertical) // 排列方向
          .scrollBar(BarState.Off)
          .friction(0.6)
          .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
          .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
          .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
            console.info('first' + firstIndex)
            console.info('last' + lastIndex)
            console.info('center' + centerIndex)
          })
          .onScrollVisibleContentChange((start: VisibleListContentInfo, end: VisibleListContentInfo) => {
            console.log(' start index: ' + start.index +
              ' start item group area: ' + start.itemGroupArea +
              ' start index in group: ' + start.itemIndexInGroup)
            console.log(' end index: ' + end.index +
              ' end item group area: ' + end.itemGroupArea +
              ' end index in group: ' + end.itemIndexInGroup)
          })
          .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
            console.info(`onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` + scrollOffset)
          })
          .width('90%')
          // 运动健康设置列表 end

          Text('安全设置').titleTextStyle()
          // 安全设置 start
          List({ space: 10, initialIndex: 0 }) {
            ForEach(this.safe_infoArr, (item: string) => {
              ListItem() {
                Text('' + item)
                  .width('100%').height(50).fontSize(16)
                  .textAlign(TextAlign.Center).borderRadius(10).backgroundColor(0xFFFFFF)
              }
            }, (item: string) => item)
          }
          .listDirection(Axis.Vertical) // 排列方向
          .scrollBar(BarState.Off)
          .friction(0.6)
          .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
          .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
          .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
            console.info('first' + firstIndex)
            console.info('last' + lastIndex)
            console.info('center' + centerIndex)
          })
          .onScrollVisibleContentChange((start: VisibleListContentInfo, end: VisibleListContentInfo) => {
            console.log(' start index: ' + start.index +
              ' start item group area: ' + start.itemGroupArea +
              ' start index in group: ' + start.itemIndexInGroup)
            console.log(' end index: ' + end.index +
              ' end item group area: ' + end.itemGroupArea +
              ' end index in group: ' + end.itemIndexInGroup)
          })
          .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
            console.info(`onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` + scrollOffset)
          })
          .width('90%')
          // 安全设置 end

        }
      }
      .scrollBar(BarState.Off)
      .allSize()
      .onScroll(() => {
        this.onScrollAction();
      })
      .align(Alignment.TopStart)

      AddBtn({
        clickAction: () => {
          this.editTaskAction();
        }
      })
      Row() {
        Text($r('app.string.Device_label'))
          .titleTextStyle()
          .fontSize($r('app.float.default_24'))
          .padding({ left: Const.THOUSANDTH_66 })
      }
      .width(Const.THOUSANDTH_1000)
      .height(Const.DEFAULT_56)
      .position({ x: 0, y: 0 })
      .backgroundColor(`rgba(${WHITE_COLOR_0X},${WHITE_COLOR_0X},${WHITE_COLOR_0X},${this.naviAlpha})`)

      DeviceCustomDialogView()
    }
    .allSize()
    .backgroundColor($r('app.color.primaryBgColor'))
  }
}

