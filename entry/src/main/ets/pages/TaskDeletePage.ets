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

import { ITaskItem, TaskItem ,TaskMapById} from '../model/TaskInitList';
import TaskList from '../view/task/TaskListComponent';
import TaskDelete from '../view/task/TaskDeleteComponent'
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { formatParams, getAllTask, taskIndexDataInit, taskOriginData } from '../viewmodel/TaskViewModel';
import TaskInfo from '../viewmodel/TaskInfo';
import { router } from '@kit.ArkUI';
import taskpool from '@ohos.taskpool';

@Entry
@Component
@Preview
struct TaskIndex {
  @Provide taskList: ITaskItem[] = taskOriginData;






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
          TaskDelete()

          Button() {
            Text($r('app.string.complete')).fontSize($r('app.float.default_20')).fontColor($r('app.color.blueColor'))
          }
          .width(Const.THOUSANDTH_800)
          .height(Const.DEFAULT_48)
          .backgroundColor($r('app.color.borderColor'))
          .onClick(() => {
            router.back({
              url: 'pages/MainPage',
               params:{
                    // editTask:formatParams(TaskItem.taskID)
               }

            })
            // this.finishTaskEdit();
          })
          .position({
            x: Const.THOUSANDTH_100,
            y: Const.THOUSANDTH_800
          })
        }
        .width(Const.THOUSANDTH_1000)
        .justifyContent(FlexAlign.Center)
      }
      .size({ width: Const.THOUSANDTH_1000, height: Const.THOUSANDTH_1000 })
      .title(Const.DELETE_TASK_TITLE)
      .titleMode(NavigationTitleMode.Mini)
    }
    .backgroundColor($r('app.color.primaryBgColor'))
    .height(Const.THOUSANDTH_1000)

  }
}