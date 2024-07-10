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

import { promptAction, router } from '@kit.ArkUI';
import { CommonConstants as Const } from '../../common/constants/CommonConstants';
import { addTask, formatParams } from '../../viewmodel/TaskViewModel';
import { ITaskItem } from '../../model/TaskInitList';
// import {TaskDeleteDialog} from '../dialog/TaskDeleteDialog'
import { BroadCast, BroadCastType } from '../../common/utils/BroadCast';
import { HealthDataSrcMgr } from '../../common/utils/HealthDataSrcMgr';
import { common } from '@kit.AbilityKit';
import TaskInfo from '../../viewmodel/TaskInfo';
import { GlobalContext } from '../../common/utils/GlobalContext';
import Logger from '../../common/utils/Logger';

@Component
export default struct TaskDelete {
  @Provide broadCast: BroadCast = HealthDataSrcMgr.getInstance().getBroadCast();
  // @Provide itemtemp: ITaskItem
  @Consume taskList: ITaskItem[];
  // @Provide itemTemp: ITaskItem
  private isChanged: boolean = false;
// TaskDeleteDialog:CustomDialogController = new CustomDialogController({
//   builder: TaskDeleteDialog({})
// }
// )


  build() {
    List({ space: Const.LIST_ITEM_SPACE }) {
      ForEach(this.taskList, (item: ITaskItem) => {
        if(item?.isOpen)
        {
          ListItem() {
            Row() {
              Row() {
                Image(item?.icon)
                  .width(Const.DEFAULT_24)
                  .height(Const.DEFAULT_24)
                  .margin({ right: Const.DEFAULT_8 })
                Text(item?.taskName)
                  .fontSize(Const.DEFAULT_20)
                  .fontColor($r('app.color.titleColor'))
              }
              .width(Const.THOUSANDTH_500)

              Blank()
                .layoutWeight(1)
              //
              // Image($r('app.media.ic_right_grey'))
              //   .width(Const.DEFAULT_8)
              //   .height(Const.DEFAULT_16)
              Toggle({ type: ToggleType.Switch, isOn: item.isOpen })
                .width(Const.DEFAULT_56)
                .height(Const.DEFAULT_32)
                .selectedColor($r('app.color.blueColor'))

                .onChange((isOn) => {
                  item.isOpen = isOn;
                  let context: Context = getContext(this) as common.Context;
                  let taskInfo: TaskInfo = new TaskInfo(Const.ZERO, Const.GLOBAL_KEY, item.taskID,
                         item.targetValue, item.isAlarm, item.startTime,
                         item.endTime, item.frequency, false, '', false);
                  addTask(taskInfo, context).then((res: number) => {
                    GlobalContext.getContext().setObject('taskListChange', true);
                    router.back({
                      url: 'pages/MainPage',
                      params:{
                        editTask:formatParams(item)
                      }

                    })
                    Logger.info('addTaskFinished', JSON.stringify(res));
                  }).catch((error: Error) => {
                    promptAction.showToast({
                      message: Const.SETTING_FINISH_FAILED_MESSAGE
                    })
                    Logger.error('addTaskFailed', JSON.stringify(error));
                  })
                })
            }
            .width(Const.THOUSANDTH_1000)
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ left: Const.DEFAULT_12, right: Const.DEFAULT_12 })
          }
          .height(Const.THOUSANDTH_80)
          .borderRadius(Const.DEFAULT_12)
          // .onClick(() => {
          //   // router.pushUrl({
          //   //   url: 'pages/TaskEditPage',
          //   //   params: {
          //   //     params: formatParams(item)
          //   //   }
          //   // })
          // // TaskDeleteDialog();
          //   item.isOpen=false
          //   // this.broadCast.emit(BroadCastType.SHOW_ACHIEVEMENT_DIALOG,item);
          //   this.TaskDeleteDialog.open()
          // //   console.log("111");
          // })
          .backgroundColor($r('app.color.white'))
        }

      }, (item: ITaskItem) => JSON.stringify(item))


    }
    .height(Const.THOUSANDTH_1000)
    .width(Const.THOUSANDTH_940)



  }
}
