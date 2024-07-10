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

import { TaskList, TaskMapById } from '../../model/TaskInitList';
import HealthText from '../../view/HealthTextComponent';
import { CommonConstants as Const } from '../../common/constants/CommonConstants';
import TaskInfo from '../../viewmodel/TaskInfo';

@Styles
function allSize() {
  .width(Const.THOUSANDTH_1000)
  .height(Const.THOUSANDTH_1000)
}

@Extend(Text)
function labelTextStyle() {
  .fontSize($r('app.float.default_16'))
  .fontWeight(Const.FONT_WEIGHT_500)
  .opacity(Const.OPACITY_6)
  .fontFamily($r('app.string.HarmonyHeiTi'))
}

@Component
export struct TaskCard {
  @Prop taskInfoStr: string = '';
  clickAction: Function = (isClick: boolean) => {
  };
  @State taskInfo: TaskInfo = new TaskInfo(-1, '', -1, '', false, '', '', '', false, '', false);

  aboutToAppear() {
    this.taskInfo = JSON.parse(this.taskInfoStr);
  }

  @Builder
  targetValueBuilder() {
    if (this.taskInfo.isDone) {
      Row() {
        if(TaskMapById[this.taskInfo.taskID-1].step !==0){
          HealthText({
            title: this.taskInfo.finValue || `--`,
            fontSize: $r('app.float.default_24')
          })
          Text(` / ${this.taskInfo.targetValue} ${TaskMapById[this.taskInfo.taskID - 1].unit}`)
            .labelTextStyle()
            .fontWeight(Const.FONT_WEIGHT_400)
        }
        HealthText({ title: '', titleResource: $r('app.string.task_done') })
      }
    } else {
      Row() {
        HealthText({
          title: this.taskInfo.finValue || `--`,
          fontSize: $r('app.float.default_24')
        })
        Text(` / ${this.taskInfo.targetValue} ${TaskMapById[this.taskInfo.taskID - 1].unit}`)
          .labelTextStyle()
          .fontWeight(Const.FONT_WEIGHT_400)
      }
    }
  }

  // 首页的任务列表
  build() {
    Row() {

      Column() {

        Column() {

      Row({ space: Const.DEFAULT_6 }) {
            // 首页的任务列表的小卡片的字体、图标
        Image(TaskMapById[this.taskInfo.taskID - 1].icon)
          .width($r('app.float.default_36')).height($r('app.float.default_36'))
          .objectFit(ImageFit.Contain)
        HealthText({
          title: '',
          titleResource: TaskMapById[this.taskInfo.taskID - 1].taskName,
          fontFamily: $r('app.string.HarmonyHeiTi')
        })
      }
        }.alignItems(HorizontalAlign.Start).width('50%')

        Column() {

          Row() {
            // 添加一个进度条
            // Text('当前' + this.taskInfo.finValue + ' 目标' + this.taskInfo.targetValue)
            if(this.taskInfo.taskID == 1 || this.taskInfo.taskID == 6) {}
            else {
              if(this.taskInfo.isDone) {
                Progress({ value: 1, total: 1, type: ProgressType.Linear })
                  // Progress({ value: 1, total: 5, type: ProgressType.Linear })
                  .height($r('app.float.default_20'))
                  .style({strokeWidth: 14, enableSmoothEffect: false})
              }
              else {
                Progress({ value: Number(this.taskInfo.finValue), total: Number(this.taskInfo.targetValue), type: ProgressType.Linear })
                  // Progress({ value: 1, total: 5, type: ProgressType.Linear })
                  .height($r('app.float.default_20'))
                  .style({strokeWidth: 14, enableSmoothEffect: false})
              }
            }

          }
        }.alignItems(HorizontalAlign.Start).width('50%')
      }

      this.targetValueBuilder();

    }
    .allSize()
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius($r('app.float.default_24'))
    .padding({ left: Const.THOUSANDTH_50, right: Const.THOUSANDTH_33 })
    .backgroundColor($r('app.color.white'))
    .onClick(() => this.clickAction(true))
    .gesture(LongPressGesture().onAction(() => this.clickAction(false)))
  }
}