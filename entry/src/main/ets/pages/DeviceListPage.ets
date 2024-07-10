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

import { ITaskItem } from '../model/TaskInitList';
// import { IDeviceItem } from '../model/DeviceInitList';
// import TaskList from '../view/task/ListComponent';
// import DeviceList from '../view/device/DeviceListComponent';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { getAllTask, taskIndexDataInit, taskOriginData } from '../viewmodel/TaskViewModel';
// import { getAllDevice, deviceIndexDataInit, deviceOriginData } from '../viewmodel/DeviceViewModel';
import TaskInfo from '../viewmodel/TaskInfo';
// import TaskInfo from '../viewmodel/DeviceInfo';

@Entry
@Component
@Preview
struct TaskIndex {
  @Provide taskList: ITaskItem[] = taskOriginData;
  private deviceArr: string[] = ["HUAWEI_PHONE", "HUAWEI_WITCH", "HUAWEI_PAD", "HUAWEI_FreeBuds"]

  onPageShow() {
    getAllTask().then((res: TaskInfo[]) => {
      let deepCopyDataStr = JSON.stringify(this.taskList);
      let deepCopyData: ITaskItem[] = JSON.parse(deepCopyDataStr);
      this.taskList = taskIndexDataInit(deepCopyData, res);
    })
  }

  build() {
    Row() {
      Navigation() {
        Column() {
          // TaskList()
          // 设备列表 start
          List({ space: 20, initialIndex: 0 }) {
            ForEach(this.deviceArr, (item: string) => {
              ListItem() {
                Text('' + item)
                  .width('100%').height(100).fontSize(16)
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
          // 设备列表 end

        }
        .width(Const.THOUSANDTH_1000)
        .justifyContent(FlexAlign.Center)
      }
      .size({ width: Const.THOUSANDTH_1000, height: Const.THOUSANDTH_1000 })
      .title(Const.DEVICE_ADMIN_TITLE)
      .titleMode(NavigationTitleMode.Mini)
    }
    .backgroundColor($r('app.color.primaryBgColor'))
    .height(Const.THOUSANDTH_1000)
  }
}