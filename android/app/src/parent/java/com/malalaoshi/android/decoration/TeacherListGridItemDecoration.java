package com.malalaoshi.android.decoration;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.view.View;

/**
 * Created by zl on 15/12/10.
 */
public class TeacherListGridItemDecoration extends RecyclerView.ItemDecoration{
    private static final int[] ATTRS = new int[]{android.R.attr.listDivider};
    private Drawable mDivider;

    public TeacherListGridItemDecoration(Context context){
        final TypedArray a = context.obtainStyledAttributes(ATTRS);
        mDivider = a.getDrawable(0);
        a.recycle();
    }

    @Override
    public void onDraw(Canvas c, RecyclerView parent, RecyclerView.State state){
//        drawHorizontal(c, parent);
//        drawVertical(c, parent);
    }

    private int getSpanCount(RecyclerView parent){
        int spanCount = -1;
        RecyclerView.LayoutManager layoutManager = parent.getLayoutManager();
        if(layoutManager instanceof GridLayoutManager){
            spanCount = ((GridLayoutManager) layoutManager).getSpanCount();
        }else if(layoutManager instanceof StaggeredGridLayoutManager){
            spanCount = ((StaggeredGridLayoutManager) layoutManager).getSpanCount();
        }
        return spanCount;
    }

    public void drawHorizontal(Canvas c, RecyclerView parent){
        int childCount = parent.getChildCount();
        for(int i = 0; i < childCount; i++){
            final View child = parent.getChildAt(i);
            final RecyclerView.LayoutParams params = (RecyclerView.LayoutParams)child.getLayoutParams();
            final int left = child.getLeft() - params.leftMargin;
            final int right = child.getRight() + params.rightMargin + mDivider.getIntrinsicWidth();
            final int top = child.getBottom() + params.bottomMargin;
            final int bottom = top + mDivider.getIntrinsicHeight();
            mDivider.setBounds(left, top, right, bottom);
            mDivider.draw(c);
        }
    }
    public void drawVertical(Canvas c, RecyclerView parent){
        final int childCount = parent.getChildCount();
        for(int i = 0; i < childCount; i++){
            final View child = parent.getChildAt(i);

            final RecyclerView.LayoutParams params = (RecyclerView.LayoutParams)child.getLayoutParams();
            final int top = child.getTop() - params.topMargin;
            final int bottom = child.getBottom() + params.bottomMargin;
            final int left = child.getRight() + params.rightMargin;
            final int right = left + mDivider.getIntrinsicWidth();

            mDivider.setBounds(left, top, right, bottom);
            mDivider.draw(c);
        }
    }

    private boolean isLastColumn(RecyclerView parent, int pos, int spanCount, int childCount){
        RecyclerView.LayoutManager layoutManager = parent.getLayoutManager();
        if(layoutManager instanceof GridLayoutManager){
            if((pos + 1) % spanCount == 0){
                return true;
            }
        }else if(layoutManager instanceof StaggeredGridLayoutManager){
            int orientation = ((StaggeredGridLayoutManager) layoutManager).getOrientation();
            if(orientation == StaggeredGridLayoutManager.VERTICAL){
                if((pos + 1) % spanCount == 0){
                    return true;
                }
            }else{
                childCount = childCount - childCount % spanCount;
                if(pos >= childCount)
                    return true;
            }
        }
        return false;
    }

    private boolean isLastRaw(RecyclerView parent, int pos, int spanCount, int childCount){
        RecyclerView.LayoutManager layoutManager = parent.getLayoutManager();
        if(layoutManager instanceof GridLayoutManager){
            childCount = childCount - childCount % spanCount;
            if(pos >= childCount)
                return true;
        }else if(layoutManager instanceof StaggeredGridLayoutManager){
            int orientation = ((StaggeredGridLayoutManager) layoutManager).getOrientation();
            if(orientation == StaggeredGridLayoutManager.VERTICAL){
                childCount = childCount - childCount % spanCount;
                if(pos >= childCount)
                    return true;
            }else{
                if((pos + 1) % spanCount == 0){
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state){
        int spanCount = getSpanCount(parent);
        int childCount = parent.getAdapter().getItemCount();
        int itemPosition = ((GridLayoutManager.LayoutParams) view.getLayoutParams()).getViewLayoutPosition();
        if(isLastRaw(parent, itemPosition, spanCount, childCount)){
            outRect.set(0, 0, mDivider.getIntrinsicWidth()+3, 0);
        }else if(isLastColumn(parent, itemPosition, spanCount, childCount)){
            outRect.set(mDivider.getIntrinsicWidth()+3, 0, 0, mDivider.getIntrinsicHeight()+8);
        }else{
            outRect.set(0, 0, mDivider.getIntrinsicWidth()+3, mDivider.getIntrinsicHeight()+8);
        }
    }
}
